package com.autoai.accessibilityspike

import android.accessibilityservice.AccessibilityService
import android.accessibilityservice.GestureDescription
import android.accessibilityservice.AccessibilityServiceInfo
import android.graphics.Path
import android.view.accessibility.AccessibilityEvent
import java.util.concurrent.CountDownLatch
import java.util.concurrent.TimeUnit

class SpikeAccessibilityService : AccessibilityService() {
  @Volatile var lastEventPackage: String? = null
    private set

  @Volatile var lastEventAtMs: Long = 0L
    private set

  override fun onServiceConnected() {
    super.onServiceConnected()
    // Improves ability to read active windows across apps.
    try {
      val info = serviceInfo ?: AccessibilityServiceInfo()
      info.flags = info.flags or AccessibilityServiceInfo.FLAG_RETRIEVE_INTERACTIVE_WINDOWS
      setServiceInfo(info)
    } catch (_: Throwable) {
      // Best-effort only (some OS versions may restrict changing this at runtime).
    }
    SpikeAccessibilityHandle.attach(this)
  }

  override fun onDestroy() {
    SpikeAccessibilityHandle.detach(this)
    super.onDestroy()
  }

  override fun onUnbind(intent: android.content.Intent?): Boolean {
    SpikeAccessibilityHandle.detach(this)
    return super.onUnbind(intent)
  }

  override fun onAccessibilityEvent(event: AccessibilityEvent?) {
    if (event == null) return
    // Keep event logging minimal to avoid leaking sensitive content.
    lastEventPackage = event.packageName?.toString()
    lastEventAtMs = System.currentTimeMillis()
    if (event.eventType == AccessibilityEvent.TYPE_WINDOW_STATE_CHANGED ||
        event.eventType == AccessibilityEvent.TYPE_WINDOW_CONTENT_CHANGED) {
      val pkg = event.packageName?.toString()
      if (pkg == "com.openai.chatgpt") {
        SpikeLog.add("ChatGPT event type=${event.eventType}")
      }
    }
  }

  override fun onInterrupt() {
    SpikeLog.add("Accessibility service interrupted.")
  }

  fun gestureTap(x: Float, y: Float, timeoutMs: Long = 1500): Boolean {
    val path = Path().apply { moveTo(x, y) }
    val gesture = GestureDescription.Builder()
      .addStroke(GestureDescription.StrokeDescription(path, 0, 1))
      .build()
    return dispatchGestureSync(gesture, timeoutMs)
  }

  fun gestureSwipeUp(
    startX: Float,
    startY: Float,
    endY: Float,
    durationMs: Long = 250,
    timeoutMs: Long = 2000
  ): Boolean {
    val path = Path().apply {
      moveTo(startX, startY)
      lineTo(startX, endY)
    }
    val gesture = GestureDescription.Builder()
      .addStroke(GestureDescription.StrokeDescription(path, 0, durationMs))
      .build()
    return dispatchGestureSync(gesture, timeoutMs)
  }

  fun gestureSwipeUpDefault(): Boolean {
    val dm = resources.displayMetrics
    val x = dm.widthPixels * 0.5f
    val startY = dm.heightPixels * 0.8f
    val endY = dm.heightPixels * 0.3f
    return gestureSwipeUp(startX = x, startY = startY, endY = endY)
  }

  private fun dispatchGestureSync(gesture: GestureDescription, timeoutMs: Long): Boolean {
    val latch = CountDownLatch(1)
    var ok = false
    val callback = object : GestureResultCallback() {
      override fun onCompleted(gestureDescription: GestureDescription?) {
        ok = true
        latch.countDown()
      }

      override fun onCancelled(gestureDescription: GestureDescription?) {
        ok = false
        latch.countDown()
      }
    }
    val started = dispatchGesture(gesture, callback, null)
    if (!started) return false
    latch.await(timeoutMs, TimeUnit.MILLISECONDS)
    return ok
  }
}
