import 'package:flutter_overlay_window/flutter_overlay_window.dart';

class AlertDialogUtils {

  static Future<void> showDialog() async {
    await FlutterOverlayWindow.showOverlay(height:500,width:500,overlayTitle: "");
  }

  static Future<void> closeAlertDialog() async {
    await FlutterOverlayWindow.closeOverlay();
  }

  static getOverlayPermission() async {
    bool status = await FlutterOverlayWindow.isPermissionGranted();
    if (!status) {
      await FlutterOverlayWindow.requestPermission();
    }
  }


}