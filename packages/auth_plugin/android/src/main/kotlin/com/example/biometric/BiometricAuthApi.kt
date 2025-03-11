// Autogenerated from Pigeon (v13.1.2), do not edit directly.
// See also: https://pub.dev/packages/pigeon
package com.example.biometric


import android.util.Log
import io.flutter.plugin.common.BasicMessageChannel
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MessageCodec
import io.flutter.plugin.common.StandardMessageCodec
import java.io.ByteArrayOutputStream
import java.nio.ByteBuffer
import androidx.core.content.ContextCompat
import android.app.Activity
import android.app.KeyguardManager
import java.util.concurrent.Executor
import android.hardware.biometrics.BiometricPrompt
import android.os.Build
import android.os.CancellationSignal
import android.widget.Toast
import androidx.appcompat.app.AppCompatActivity
import kotlin.coroutines.resume
import kotlin.coroutines.resumeWithException
import kotlin.coroutines.suspendCoroutine
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext


class BiometricAuthImpl(private val activity: Activity) : BiometricAuthApi {
  private lateinit var biometricPrompt: BiometricPrompt
  private var cancellationSignal: CancellationSignal? = null

  override suspend fun authenticate(): AuthResult {
    return suspendCoroutine { continuation ->

      val executor: Executor = ContextCompat.getMainExecutor(activity)

      biometricPrompt = BiometricPrompt.Builder(activity)
        .setTitle("Autenticación biométrica")
        .setSubtitle("Inicie sesión usando su huella o reconocimiento facial")
        .setDescription("Escanee su biometría para continuar")
        .setNegativeButton("Cancelar", executor) { _, _ ->
          continuation.resume(AuthResult( "Autenticación cancelada", false))
        }
        .build()


      cancellationSignal = CancellationSignal()
      cancellationSignal?.setOnCancelListener {
        continuation.resume(AuthResult( "Autenticación cancelada", false))
      }
      biometricPrompt.authenticate(cancellationSignal as CancellationSignal, executor,
        object : BiometricPrompt.AuthenticationCallback() {
          override fun onAuthenticationSucceeded(result: BiometricPrompt.AuthenticationResult) {
            continuation.resume(AuthResult( null, true))
          }

          override fun onAuthenticationError(errorCode: Int, errString: CharSequence) {
            continuation.resume(AuthResult( errString.toString(), false))
          }
        })
    }
  }
}


private fun wrapResult(result: Any?): List<Any?> {
  return listOf(result)
}

private fun wrapError(exception: Throwable): List<Any?> {
  if (exception is FlutterError) {
    return listOf(
      exception.code,
      exception.message,
      exception.details
    )
  } else {
    return listOf(
      exception.javaClass.simpleName,
      exception.toString(),
      "Cause: " + exception.cause + ", Stacktrace: " + Log.getStackTraceString(exception)
    )
  }
}

/**
 * Error class for passing custom error details to Flutter via a thrown PlatformException.
 * @property code The error code.
 * @property message The error message.
 * @property details The error details. Must be a datatype supported by the api codec.
 */
class FlutterError (
  val code: String,
  override val message: String? = null,
  val details: Any? = null
) : Throwable()

/** Generated class from Pigeon that represents data sent in messages. */
data class AuthResult (
  val errorMessage: String? = null,
  val isSuccess: Boolean

) {
  companion object {
    @Suppress("UNCHECKED_CAST")
    fun fromList(list: List<Any?>): AuthResult {
      val errorMessage = list[0] as String?
      val isSuccess = list[1] as Boolean
      return AuthResult(errorMessage, isSuccess)
    }
  }
  fun toList(): List<Any?> {
    return listOf<Any?>(
      errorMessage,
      isSuccess,
    )
  }
}
@Suppress("UNCHECKED_CAST")
private object BiometricAuthApiCodec : StandardMessageCodec() {
  override fun readValueOfType(type: Byte, buffer: ByteBuffer): Any? {
    return when (type) {
      128.toByte() -> {
        return (readValue(buffer) as? List<Any?>)?.let {
          AuthResult.fromList(it)
        }
      }
      else -> super.readValueOfType(type, buffer)
    }
  }
  override fun writeValue(stream: ByteArrayOutputStream, value: Any?)   {
    when (value) {
      is AuthResult -> {
        stream.write(128)
        writeValue(stream, value.toList())
      }
      else -> super.writeValue(stream, value)
    }
  }
}

/** Generated interface from Pigeon that represents a handler of messages from Flutter. */
interface BiometricAuthApi {
  suspend fun authenticate(): AuthResult

  companion object {
    /** The codec used by BiometricAuthApi. */
    val codec: MessageCodec<Any?> by lazy {
      BiometricAuthApiCodec
    }
    /** Sets up an instance of `BiometricAuthApi` to handle messages through the `binaryMessenger`. */
    @Suppress("UNCHECKED_CAST")
    fun setUp(binaryMessenger: BinaryMessenger, api: BiometricAuthApi?) {
      run {
        val channel = BasicMessageChannel<Any?>(binaryMessenger, "dev.flutter.pigeon.auth.BiometricAuthApi.authenticate", codec)
        if (api != null) {
          channel.setMessageHandler { _, reply ->
            CoroutineScope(Dispatchers.Main).launch {
              var wrapped: List<Any?>
              try {
                wrapped = listOf<Any?>(api.authenticate())
              } catch (exception: Throwable) {
                wrapped = wrapError(exception)
              }
              reply.reply(wrapped)
            }
          }
        } else {
          channel.setMessageHandler(null)
        }
      }
    }
  }
}
