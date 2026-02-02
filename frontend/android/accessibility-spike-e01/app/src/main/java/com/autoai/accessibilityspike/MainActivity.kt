package com.autoai.accessibilityspike

import android.content.Intent
import android.os.Bundle
import android.provider.Settings
import android.widget.Button
import android.widget.TextView
import androidx.appcompat.app.AppCompatActivity
import java.util.concurrent.Executors

class MainActivity : AppCompatActivity() {
  private val executor = Executors.newSingleThreadExecutor()

  private lateinit var logView: TextView

  private fun openChatGpt() {
    val intent = packageManager.getLaunchIntentForPackage("com.openai.chatgpt")
    if (intent == null) {
      SpikeLog.add("ChatGPT app not installed (package com.openai.chatgpt).")
      renderLog()
      return
    }
    intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
    startActivity(intent)
  }

  private fun waitForChatGptActive(timeoutMs: Long = 5000): Boolean {
    val deadline = System.currentTimeMillis() + timeoutMs
    while (System.currentTimeMillis() < deadline) {
      // Prefer root/window check, but accept "recent ChatGPT event" as signal too.
      if (SpikeAccessibilityHandle.isChatGptActiveWindow()) return true
      val pkg = SpikeAccessibilityHandle.activePackageName()
      if (pkg == "com.openai.chatgpt") return true
      Thread.sleep(200)
    }
    return false
  }

  override fun onCreate(savedInstanceState: Bundle?) {
    super.onCreate(savedInstanceState)
    setContentView(R.layout.activity_main)

    logView = findViewById(R.id.logView)

    findViewById<Button>(R.id.openAccessibilitySettings).setOnClickListener {
      startActivity(Intent(Settings.ACTION_ACCESSIBILITY_SETTINGS))
    }

    findViewById<Button>(R.id.clearLog).setOnClickListener {
      SpikeLog.clear()
      renderLog()
    }

    findViewById<Button>(R.id.detectScreen).setOnClickListener {
      executor.execute {
        runOnUiThread { openChatGpt() }
        val ok = waitForChatGptActive()
        if (!ok) {
          SpikeLog.add("ChatGPT did not become the active screen. Open ChatGPT and keep it on screen, then retry.")
          runOnUiThread { renderLog() }
          return@execute
        }
        val r = SpikeAccessibilityHandle.detectScreen()
        SpikeLog.add("Detect screen=${r.screen} reason=${r.reason} pkg=${r.packageName}")
        runOnUiThread { renderLog() }
      }
    }

    findViewById<Button>(R.id.readTitles).setOnClickListener {
      executor.execute {
        runOnUiThread { openChatGpt() }
        val ok = waitForChatGptActive()
        if (!ok) {
          SpikeLog.add("ChatGPT did not become the active screen. Open ChatGPT and keep it on screen, then retry.")
          runOnUiThread { renderLog() }
          return@execute
        }
        val titles = SpikeAccessibilityHandle.readVisibleTitles()
        SpikeLog.add("Read titles count=${titles.size}")
        titles.take(30).forEachIndexed { i, t -> SpikeLog.add("  ${i + 1}: $t") }
        runOnUiThread { renderLog() }
      }
    }

    findViewById<Button>(R.id.scrollToEnd).setOnClickListener {
      executor.execute {
        runOnUiThread { openChatGpt() }
        val ok = waitForChatGptActive(timeoutMs = 8000)
        if (!ok) {
          SpikeLog.add("ChatGPT did not become the active screen. Open ChatGPT and keep it on screen, then retry.")
          runOnUiThread { renderLog() }
          return@execute
        }
        val r = SpikeAccessibilityHandle.scrollToEnd()
        SpikeLog.add("ScrollToEnd reachedEnd=${r.reachedEnd} steps=${r.steps} lastTitle=${r.lastTitle ?: "<none>"}")
        runOnUiThread { renderLog() }
      }
    }

    findViewById<Button>(R.id.openFirstTitle).setOnClickListener {
      executor.execute {
        runOnUiThread { openChatGpt() }
        val activated = waitForChatGptActive()
        if (!activated) {
          SpikeLog.add("ChatGPT did not become the active screen. Open ChatGPT and keep it on screen, then retry.")
          runOnUiThread { renderLog() }
          return@execute
        }
        val opened = SpikeAccessibilityHandle.openFirstVisibleTitle()
        SpikeLog.add("OpenFirstTitle ok=$opened (should open item #1 from last read)")
        runOnUiThread { renderLog() }
      }
    }

    SpikeLog.add("App started. Enable service, open ChatGPT, then run actions.")
    renderLog()
  }

  private fun renderLog() {
    logView.text = SpikeLog.snapshot().joinToString(separator = "\n")
  }
}
