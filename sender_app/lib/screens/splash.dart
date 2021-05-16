import 'package:flutter/material.dart';
import 'package:sender_app/screens/home.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(Duration(seconds: 2), () {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => HomePage(),
            ),
            (_) => false);
      });
    });
    return Scaffold(
      body: Center(
        child: Text('Splash - @Logo'),
      ),
    );
  }
}
