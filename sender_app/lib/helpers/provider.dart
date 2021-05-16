import 'package:flutter/material.dart';

class RetroProvider extends ChangeNotifier {
  bool _isConnected;

  set isConnected(bool b) {
    _isConnected = b;
    notifyListeners();
  }

  get isConnected => _isConnected;

  RetroProvider() {
    _isConnected = false; // Get Bluetooth connection and check for RetroDevice.
  }
}
