import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  static Future<void> checkAndRequest() async {
    final bluetoothScan = await Permission.bluetoothScan.status;
    final bluetoothConnect = await Permission.bluetoothConnect.status;
    final location = await Permission.location.status;

    if (!bluetoothScan.isGranted) {
      await Permission.bluetoothScan.request();
    }
    if (!bluetoothConnect.isGranted) {
      await Permission.bluetoothConnect.request();
    }
    if (!location.isGranted) {
      await Permission.location.request();
    }
  }
}