package com.example.ecoblock_mobile

import android.bluetooth.*
import android.content.Context
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "ecoblock/gatt_server"
    private var gattServer: BluetoothGattServer? = null

    override fun configureFlutterEngine(flutterEngine: io.flutter.embedding.engine.FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "startGattServer") {
                val nodeId = call.argument<String>("nodeId") ?: "unknown"
                startGattServer(nodeId)
                result.success(true)
            }
        }
    }

    private fun startGattServer(nodeId: String) {
        val bluetoothManager = getSystemService(Context.BLUETOOTH_SERVICE) as BluetoothManager
        val bluetoothAdapter = bluetoothManager.adapter
        gattServer = bluetoothManager.openGattServer(this, object : BluetoothGattServerCallback() {})
        val service = BluetoothGattService(
            java.util.UUID.fromString("0000181C-0000-1000-8000-00805f9b34fb"),
            BluetoothGattService.SERVICE_TYPE_PRIMARY
        )
        val characteristic = BluetoothGattCharacteristic(
            java.util.UUID.fromString("00002A99-0000-1000-8000-00805f9b34fb"),
            BluetoothGattCharacteristic.PROPERTY_READ,
            BluetoothGattCharacteristic.PERMISSION_READ
        )
        characteristic.value = nodeId.toByteArray()
        service.addCharacteristic(characteristic)
        gattServer?.addService(service)
    }
}
