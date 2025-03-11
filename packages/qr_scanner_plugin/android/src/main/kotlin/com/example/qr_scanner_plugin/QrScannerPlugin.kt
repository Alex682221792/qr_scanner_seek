package com.example.qr_scanner_plugin

import android.Manifest
import android.util.Log
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import android.app.Activity
import android.content.Intent
import android.content.pm.PackageManager
import androidx.activity.result.ActivityResultLauncher
import androidx.activity.result.contract.ActivityResultContracts
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodChannel
import com.example.qrcode.QRCodeScannerApiImpl
import com.example.qrcode.QRCodeScannerApi

/** QrScannerPlugin */
class QrScannerPlugin: FlutterPlugin, MethodCallHandler, ActivityAware {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var channel : MethodChannel
  private lateinit var activity: Activity//? = null
  private lateinit var flutterPluginBinding: FlutterPlugin.FlutterPluginBinding
  private val CAMERA_PERMISSION_CODE = 1001
  private var pendingResult: Result? = null


  override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    this.flutterPluginBinding = flutterPluginBinding
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "qr_scanner_plugin")
    channel.setMethodCallHandler(this)
  }

  override fun onMethodCall(call: MethodCall, result: Result) {
    if (call.method == "setUp") {
      QRCodeScannerApi.setUp(flutterPluginBinding.binaryMessenger,
        QRCodeScannerApiImpl(activity))
      requestCameraPermission(result)
    } else {
      result.notImplemented()
    }
  }

  private fun requestCameraPermission(result: Result) {
    activity?.let {
      if (ContextCompat.checkSelfPermission(it, Manifest.permission.CAMERA) == PackageManager.PERMISSION_GRANTED) {
        result.success(true) // Permiso ya concedido
      } else {
        pendingResult = result
        ActivityCompat.requestPermissions(it, arrayOf(Manifest.permission.CAMERA), CAMERA_PERMISSION_CODE)
      }
    } ?: result.error("NO_ACTIVITY", "No activity attached", null)
  }

  fun onRequestPermissionsResult(requestCode: Int, permissions: Array<out String>, grantResults: IntArray) {
    if (requestCode == CAMERA_PERMISSION_CODE) {
      val granted = grantResults.isNotEmpty() && grantResults[0] == PackageManager.PERMISSION_GRANTED
      pendingResult?.success(granted)
      pendingResult = null
    }
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }

  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    activity = binding.activity
  }

  override fun onDetachedFromActivity() {
    //activity = null
    Log.d("QRCodePlugin", "Actividad removida")
  }

  override fun onDetachedFromActivityForConfigChanges() {
    //activity = null
    Log.d("QRCodePlugin", "Actividad removida")
  }

  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    activity = binding.activity
    Log.d("QRCodePlugin", "Actividad removida")
  }

}
