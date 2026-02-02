package com.autoai.accessibilityspike

import java.text.SimpleDateFormat
import java.util.Date
import java.util.Locale

object SpikeLog {
  private val lock = Any()
  private val lines = ArrayDeque<String>()
  private val ts = SimpleDateFormat("HH:mm:ss.SSS", Locale.US)

  fun add(message: String) {
    val line = "${ts.format(Date())}  $message"
    synchronized(lock) {
      lines.addLast(line)
      while (lines.size > 400) lines.removeFirst()
    }
  }

  fun clear() {
    synchronized(lock) { lines.clear() }
  }

  fun snapshot(): List<String> {
    synchronized(lock) { return lines.toList() }
  }
}

