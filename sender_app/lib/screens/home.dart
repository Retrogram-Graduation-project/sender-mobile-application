import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key key}) : super(key: key);

  /// Must confirm if there is a connected device or not. [RetroProvider.isConnected]
  // Check for bluetooth.

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Home page'),
      ),
    );
  }
}
