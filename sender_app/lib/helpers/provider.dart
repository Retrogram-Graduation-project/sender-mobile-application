import 'package:flutter/material.dart';
import 'package:nearby_connections/nearby_connections.dart';

class RetroProvider extends ChangeNotifier {
  bool _isConnected;
  String deviceName;

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
    deviceName =
        'Retro 3'; // Get Device name if there is a connected RetroDevice.
  }
}
