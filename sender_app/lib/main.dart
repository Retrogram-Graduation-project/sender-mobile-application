import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sender_app/helpers/provider.dart';
import 'package:sender_app/screens/splash.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => RetroProvider(),
      child: MaterialApp(
        home: SplashScreen(),
      ),
    );
  }
}
