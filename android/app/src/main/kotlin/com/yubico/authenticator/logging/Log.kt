package com.yubico.authenticator.logging

import android.util.Log
import com.yubico.authenticator.BuildConfig

object Log {

    enum class LogLevel {
        TRAFFIC,
        DEBUG,
        INFO,
        WARNING,
        ERROR
    }

    const val MAX_BUFFER_SIZE = 1000
    private val _buffer = arrayListOf<String>()

    fun getBuffer() : List<String> {
        return _buffer
    }

    private var level = if (BuildConfig.DEBUG) {
        LogLevel.DEBUG
    } else {
        LogLevel.INFO
    }

    private const val TAG = "yubico-authenticator"

    @Suppress("unused")
    fun t(tag: String, message: String, error: String? = null) {
        log(LogLevel.TRAFFIC, tag, message, error)
    }

    @Suppress("unused")
    fun d(tag: String, message: String, error: String? = null) {
        log(LogLevel.DEBUG, tag, message, error)
    }

    @Suppress("unused")
    fun i(tag: String, message: String, error: String? = null) {
        log(LogLevel.INFO, tag, message, error)
    }

    @Suppress("unused")
    fun w(tag: String, message: String, error: String? = null) {
        log(LogLevel.WARNING, tag, message, error)
    }

    @Suppress("unused")
    fun e(tag: String, message: String, error: String? = null) {
        log(LogLevel.ERROR, tag, message, error)
    }

    @Suppress("unused")
    fun log(level: LogLevel, loggerName: String, message: String, error: String?) {
        if (level < this.level) {
            return
        }

        if (_buffer.size > MAX_BUFFER_SIZE) {
            _buffer.removeAt(0)
        }

        val logMessage = "[$loggerName] ${level.name}: $message".also {
            _buffer.add(it)
        }

        when (level) {
            LogLevel.TRAFFIC -> Log.v(TAG, logMessage)
            LogLevel.DEBUG -> Log.d(TAG, logMessage)
            LogLevel.INFO -> Log.i(TAG, logMessage)
            LogLevel.WARNING -> Log.w(TAG, logMessage)
            LogLevel.ERROR -> Log.e(TAG, logMessage)
        }

        error?.let {
            Log.e(TAG, "[$loggerName] ${level.name}: $error".also {
                _buffer.add(it)
            })
        }
    }

    @Suppress("unused")
    fun setLevel(newLevel: LogLevel) {
        level = newLevel
    }
}