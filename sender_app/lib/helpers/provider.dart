import 'package:flutter/material.dart';
import 'package:nearby_connections/nearby_connections.dart';
import 'package:sender_app/models/device.dart';

class RetroProvider extends ChangeNotifier {
  bool _isConnected;
  RetroDevice device;

  set isConnected(bool b) {
    _isConnected = b;
    notifyListeners();
  }

  get isConnected => _isConnected;

  void grantPermissions() async {
    if (!await Nearby().checkLocationPermission())
      Nearby().askLocationPermission();

    // if (!await Nearby().checkExternalStoragePermission())
    //   Nearby().askExternalStoragePermission();
  }

  RetroProvider() {
    grantPermissions();
    _isConnected = false; // Get Bluetooth connection and check for RetroDevice.
    device =
        RetroDevice(); // Get Device name if there is a connected RetroDevice.
  }
}
