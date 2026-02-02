package com.autoai.accessibilityspike

import android.graphics.Rect
import android.view.accessibility.AccessibilityNodeInfo

object SpikeAccessibilityHandle {
  private const val TARGET_PACKAGE = "com.openai.chatgpt"

  @Volatile private var service: SpikeAccessibilityService? = null
  @Volatile private var lastVisibleTitles: List<TitleHit> = emptyList()
  @Volatile private var lastVisibleTitlesAtMs: Long = 0L

  fun attach(svc: SpikeAccessibilityService) {
    service = svc
    SpikeLog.add("Accessibility service connected.")
  }

  fun detach(svc: SpikeAccessibilityService) {
    if (service === svc) {
      service = null
      SpikeLog.add("Accessibility service disconnected.")
    }
  }

  data class DetectionResult(
    val screen: ScreenType,
    val reason: String,
    val packageName: String?
  )

  data class ScrollResult(
    val reachedEnd: Boolean,
    val steps: Int,
    val lastTitle: String?
  )

  data class TitleHit(
    val title: String,
    val clickRect: Rect,
    val tapX: Int,
    val tapY: Int
  )

  enum class ScreenType { Chats, Projects, Unknown }

  fun activePackageName(): String? {
    val svc = service ?: return null
    // rootInActiveWindow can be null on some devices until an accessibility event arrives.
    val rootPkg = svc.rootInActiveWindow?.packageName?.toString()
    if (!rootPkg.isNullOrBlank()) return rootPkg

    // Fallback: best-effort from interactive windows.
    val winPkg = try {
      svc.windows
        ?.asSequence()
        ?.mapNotNull { it.root?.packageName?.toString() }
        ?.firstOrNull()
    } catch (_: Throwable) {
      null
    }
    if (!winPkg.isNullOrBlank()) return winPkg

    // Fallback: last accessibility event we saw.
    return svc.lastEventPackage
  }

  fun isChatGptActiveWindow(): Boolean {
    return activePackageName() == TARGET_PACKAGE
  }

  fun detectScreen(): DetectionResult {
    val root = getChatGptRootOrNull()
      ?: return DetectionResult(
        ScreenType.Unknown,
        "ChatGPT is not the active screen (or window is not accessible).",
        activePackageName()
      )

    val pkg = root.packageName?.toString()
    val texts = collectVisibleTexts(root)

    if (texts.any { it.equals("Projects", ignoreCase = true) }) {
      return DetectionResult(ScreenType.Projects, "Found visible text: Projects", pkg)
    }
    if (texts.any { it.equals("Chats", ignoreCase = true) }) {
      return DetectionResult(ScreenType.Chats, "Found visible text: Chats", pkg)
    }

    return DetectionResult(ScreenType.Unknown, "No Projects/Chats labels found in visible text nodes.", pkg)
  }

  fun readVisibleTitles(): List<String> {
    val hits = readVisibleTitleHits(refreshCache = true)
    return hits.map { it.title }
  }

  fun openFirstVisibleTitle(): Boolean {
    val hits = readVisibleTitleHits(refreshCache = false)
    if (hits.isEmpty()) {
      SpikeLog.add("No titles available to open.")
      return false
    }
    return openByIndex(0)
  }

  fun openByIndex(index: Int): Boolean {
    val hits = readVisibleTitleHits(refreshCache = false)
    if (index < 0 || index >= hits.size) {
      SpikeLog.add("OpenByIndex failed: index=$index out of range (size=${hits.size}).")
      return false
    }
    val hit = hits[index]
    SpikeLog.add("OpenByIndex index=${index + 1} title='${hit.title}' rect=${hit.clickRect.flattenToString()}")
    return openByHit(hit)
  }

  private fun openByHit(hit: TitleHit): Boolean {
    val root = getChatGptRootOrNull() ?: return false
    val scopeRoot = findBestScrollableNode(root) ?: root

    val anchorX = hit.tapX
    val anchorY = hit.tapY

    val matches = mutableListOf<AccessibilityNodeInfo>()
    walk(scopeRoot) { node ->
      val t = node.text?.toString()?.trim()
      if (t == hit.title) matches.add(node)
    }

    var best: AccessibilityNodeInfo? = null
    var bestDist = Int.MAX_VALUE
    val tmp = Rect()
    val textRect = Rect()
    for (node in matches) {
      node.getBoundsInScreen(textRect)
      val clickable = bestClickTarget(node, textRect) ?: node
      clickable.getBoundsInScreen(tmp)
      if (tmp.isEmpty) continue
      val dx = tmp.centerX() - anchorX
      val dy = tmp.centerY() - anchorY
      val d = dx * dx + dy * dy
      if (d < bestDist) {
        bestDist = d
        best = clickable
      }
    }

    if (best != null) {
      val clickOk = best.performAction(AccessibilityNodeInfo.ACTION_CLICK)
      if (clickOk) {
        SpikeLog.add("Open title='${hit.title}' via ACTION_CLICK ok=true (bestDist=$bestDist)")
        return true
      }
    }

    val cx = hit.tapX.toFloat()
    val cy = hit.tapY.toFloat()
    val tapOk = gestureTap(cx, cy)
    SpikeLog.add("Open title='${hit.title}' via gestureTap ok=$tapOk")
    return tapOk
  }

  private fun readVisibleTitleHits(refreshCache: Boolean): List<TitleHit> {
    val now = System.currentTimeMillis()
    if (!refreshCache && lastVisibleTitles.isNotEmpty() && (now - lastVisibleTitlesAtMs) < 30_000) {
      return lastVisibleTitles
    }

    val root = getChatGptRootOrNull() ?: run {
      lastVisibleTitles = emptyList()
      lastVisibleTitlesAtMs = now
      return emptyList()
    }
    val scopeRoot = findBestScrollableNode(root) ?: root

    data class Candidate(
      val title: String,
      val sortTop: Int,
      val clickRect: Rect,
      val tapX: Int,
      val tapY: Int
    )
    val candidates = mutableListOf<Candidate>()

    walk(scopeRoot) { node ->
      val text = node.text?.toString()?.trim().orEmpty()
      if (text.isEmpty()) return@walk
      if (text.length > 80) return@walk
      if (text.equals("Projects", ignoreCase = true)) return@walk
      if (text.equals("Chats", ignoreCase = true)) return@walk

      if (node.className?.toString()?.contains("TextView") != true) return@walk

      val textRect = Rect()
      node.getBoundsInScreen(textRect)
      if (textRect.isEmpty) return@walk

      val clickTarget = bestClickTarget(node, textRect) ?: node
      val clickRect = Rect()
      clickTarget.getBoundsInScreen(clickRect)
      if (clickRect.isEmpty) clickRect.set(textRect)

      val tapX = textRect.centerX()
      val tapY = textRect.centerY()

      // IMPORTANT: sort by textRect.top (not clickRect.top), because clickRect can be a large container and
      // cause unstable ordering.
      candidates.add(
        Candidate(
          title = text,
          sortTop = textRect.top,
          clickRect = clickRect,
          tapX = tapX,
          tapY = tapY
        )
      )
    }

    // De-dup by text + approximate vertical position.
    val seen = HashSet<String>()
    val out = mutableListOf<TitleHit>()
    for (c in candidates.sortedBy { it.sortTop }) {
      val key = "${c.title.lowercase()}@${c.sortTop / 8}"
      if (seen.add(key)) out.add(TitleHit(c.title, c.clickRect, c.tapX, c.tapY))
    }

    lastVisibleTitles = out
    lastVisibleTitlesAtMs = now
    return out
  }

  fun scrollToEnd(maxScrolls: Int = 50, stableTailRepeats: Int = 3): ScrollResult {
    val root = getChatGptRootOrNull() ?: return ScrollResult(false, 0, null)

    val scrollNode = findBestScrollableNode(root)
      ?: run {
        SpikeLog.add("No scrollable node found (no ACTION_SCROLL_FORWARD). Will try gesture scroll.")
        null
      }

    var stable = 0
    var lastTail: String? = null
    var steps = 0

    while (steps < maxScrolls) {
      val titles = readVisibleTitles()
      val tail = titles.lastOrNull()
      if (tail != null && tail == lastTail) stable++ else stable = 0
      lastTail = tail

      SpikeLog.add("Scroll step=$steps tail=${tail ?: "<none>"} stable=$stable/$stableTailRepeats")
      if (stable >= stableTailRepeats) {
        SpikeLog.add("Reached end (tail stable).")
        return ScrollResult(true, steps, lastTail)
      }

      val ok = scrollNode?.performAction(AccessibilityNodeInfo.ACTION_SCROLL_FORWARD) ?: false
      steps++
      if (ok) {
        Thread.sleep(250)
        continue
      }

      SpikeLog.add("ACTION_SCROLL_FORWARD failed; trying gesture swipe.")
      val gestureOk = gestureScrollFallback()
      if (!gestureOk) {
        SpikeLog.add("Gesture swipe failed.")
        return ScrollResult(false, steps, lastTail)
      }

      // Give UI time to update.
      Thread.sleep(250)
    }

    SpikeLog.add("Hit maxScrolls=$maxScrolls without stable tail.")
    return ScrollResult(false, steps, lastTail)
  }

  fun openByTitle(title: String): Boolean {
    val root = getChatGptRootOrNull() ?: return false
    val target = findFirstNodeByExactText(root, title) ?: run {
      SpikeLog.add("Could not find node with title: $title")
      return false
    }

    val clickable = closestClickable(target) ?: target
    val clickOk = clickable.performAction(AccessibilityNodeInfo.ACTION_CLICK)
    if (clickOk) {
      SpikeLog.add("Open title='$title' via ACTION_CLICK ok=true")
      return true
    }

    val rect = Rect()
    clickable.getBoundsInScreen(rect)
    if (rect.isEmpty) {
      SpikeLog.add("Open title='$title' failed: empty bounds.")
      return false
    }

    val tapOk = gestureTap(rect.centerX().toFloat(), rect.centerY().toFloat())
    SpikeLog.add("Open title='$title' via gestureTap ok=$tapOk")
    return tapOk
  }

  private fun getChatGptRootOrNull(): AccessibilityNodeInfo? {
    val svc = service ?: run {
      SpikeLog.add("Accessibility service not connected (enable it in Settings).")
      return null
    }
    val roots = mutableListOf<AccessibilityNodeInfo>()
    svc.rootInActiveWindow?.let { roots.add(it) }
    try {
      svc.windows?.forEach { w -> w.root?.let { roots.add(it) } }
    } catch (_: Throwable) {
      // ignore
    }
    val match = roots.firstOrNull { it.packageName?.toString() == TARGET_PACKAGE }
    if (match == null) {
      SpikeLog.add("ChatGPT window root not found. lastEventPackage='${svc.lastEventPackage}'")
      return null
    }
    return match
  }

  private fun gestureScrollFallback(): Boolean {
    val svc = service ?: return false
    return svc.gestureSwipeUpDefault()
  }

  private fun gestureTap(x: Float, y: Float): Boolean {
    val svc = service ?: return false
    return svc.gestureTap(x, y)
  }

  private fun findBestScrollableNode(root: AccessibilityNodeInfo): AccessibilityNodeInfo? {
    var best: AccessibilityNodeInfo? = null
    walk(root) { node ->
      val hasScroll = node.actionList.any { it.id == AccessibilityNodeInfo.ACTION_SCROLL_FORWARD }
      if (!hasScroll) return@walk
      best = node
    }
    return best
  }

  private fun findFirstNodeByExactText(root: AccessibilityNodeInfo, title: String): AccessibilityNodeInfo? {
    var found: AccessibilityNodeInfo? = null
    walk(root) { node ->
      if (found != null) return@walk
      val t = node.text?.toString()
      if (t != null && t.trim() == title) {
        found = node
      }
    }
    return found
  }

  private fun closestClickable(node: AccessibilityNodeInfo): AccessibilityNodeInfo? {
    var cur: AccessibilityNodeInfo? = node
    var hops = 0
    while (cur != null && hops < 6) {
      if (cur.isClickable) return cur
      cur = cur.parent
      hops++
    }
    return null
  }

  private fun bestClickTarget(node: AccessibilityNodeInfo, textRect: Rect): AccessibilityNodeInfo? {
    var cur: AccessibilityNodeInfo? = node
    var hops = 0
    var best: AccessibilityNodeInfo? = null
    var bestArea = Int.MAX_VALUE
    val tmp = Rect()
    val cx = textRect.centerX()
    val cy = textRect.centerY()

    while (cur != null && hops < 10) {
      val hasClick =
        cur.isClickable || cur.actionList.any { it.id == AccessibilityNodeInfo.ACTION_CLICK }
      if (hasClick) {
        cur.getBoundsInScreen(tmp)
        if (!tmp.isEmpty && tmp.contains(cx, cy)) {
          val area = tmp.width() * tmp.height()
          if (area in 1 until bestArea) {
            best = cur
            bestArea = area
          }
        }
      }
      cur = cur.parent
      hops++
    }

    return best
  }

  private fun collectVisibleTexts(root: AccessibilityNodeInfo): List<String> {
    val out = mutableListOf<String>()
    walk(root) { node ->
      val t = node.text?.toString()?.trim()
      if (!t.isNullOrEmpty()) out.add(t)
    }
    return out
  }

  private inline fun walk(root: AccessibilityNodeInfo, fn: (AccessibilityNodeInfo) -> Unit) {
    val queue = ArrayDeque<AccessibilityNodeInfo>()
    queue.add(root)
    var guard = 0
    while (queue.isNotEmpty() && guard < 50_000) {
      val n = queue.removeFirst()
      fn(n)
      for (i in 0 until n.childCount) {
        val c = n.getChild(i) ?: continue
        queue.add(c)
      }
      guard++
    }
    if (guard >= 50_000) SpikeLog.add("Node walk guard hit (50k).")
  }
}
