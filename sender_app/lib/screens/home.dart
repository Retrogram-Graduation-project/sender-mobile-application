import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sender_app/helpers/provider.dart';
import 'package:sender_app/styles/style.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key key}) : super(key: key);

  /// Must confirm if there is a connected device or not. [RetroProvider.isConnected]
  // Check for bluetooth.

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      extendBodyBehindAppBar: true,
      backgroundColor: Color(0xff000b31),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
                'assets/background1.png'), // "background" without half logos, "background1" with.
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            !Provider.of<RetroProvider>(context).isConnected
                ? connected(context)
                : notConnected(context),
          ],
        ),
      ),
    );
  }

  Widget appBar() => AppBar(
        title: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'RETRO',
                style: TextStyle(
                  fontSize: 24,
                  letterSpacing: 2,
                ),
              ),
              Icon(Icons.settings),
            ],
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      );

  Widget notConnected(context) => Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        padding: EdgeInsets.symmetric(vertical: 60),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              margin: EdgeInsets.symmetric(vertical: 50),
              child: Text(
                'No connected RetroDevice.',
                style: TextStyle(
                  letterSpacing: 1.5,
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            GestureDetector(
              // Implement connecting to Bluetooth
              onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Implement connecting to Bluetooth'))),
              child: Container(
                padding: EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 20,
                ),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue,
                      spreadRadius: 2,
                      blurRadius: 7,
                      offset: Offset(0, 4), // changes position of shadow
                    ),
                  ],
                ),
                child: Text(
                  'Connect',
                  style: TextStyle(
                    letterSpacing: 1.5,
                    color: Colors.white,
                    fontSize: 22,
                  ),
                ),
              ),
            ),
          ],
        ),
      );

  Widget connected(context) => Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        padding: EdgeInsets.symmetric(vertical: 60),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(height: 60),
            Text(
              'Connected to',
              textAlign: TextAlign.center,
              style: TextStyle(
                letterSpacing: 1.5,
                color: Colors.white,
                fontSize: 24,
              ),
            ),
            Text(
              Provider.of<RetroProvider>(context).deviceName.toUpperCase(),
              textAlign: TextAlign.center,
              style: TextStyle(
                letterSpacing: 1.5,
                color: RetroColors.secondaryColor,
                fontSize: 21,
              ),
            ),
            SizedBox(height: 200),
            Text(
              'Select object\nto preview'.toUpperCase(),
              textAlign: TextAlign.center,
              style: TextStyle(
                letterSpacing: 2,
                color: Colors.grey[300].withOpacity(0.8),
                fontSize: 15,
              ),
            ),
            SizedBox(height: 10),
            GestureDetector(
              // Implement selecting image.
              onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Implement selecting image'))),
              child: Container(
                padding: EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 20,
                ),
                decoration: BoxDecoration(
                  color: RetroColors.secondaryColor,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue,
                      spreadRadius: 2,
                      blurRadius: 7,
                      offset: Offset(0, 4), // changes position of shadow
                    ),
                  ],
                ),
                child: Text(
                  'Select'.toUpperCase(),
                  style: TextStyle(
                    letterSpacing: 1.5,
                    color: Colors.white,
                    fontSize: 22,
                  ),
                ),
              ),
            ),
            SizedBox(height: 90),
            Text(
              'Sample for trial'.toUpperCase(),
              textAlign: TextAlign.center,
              style: TextStyle(
                letterSpacing: 2,
                color: Colors.grey[300].withOpacity(0.9),
                fontSize: 15,
              ),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                sample(),
                sample(),
                sample(),
              ],
            ),
          ],
        ),
      );

  // Pass an image or a text to preview in sample.
  Widget sample({String title, String imgPath}) => Container(
        width: 50,
        height: 50,
        margin: EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(
            color: RetroColors.secondaryColor,
            width: 0.5,
          ),
          color: Color(0xff000b31),
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: RetroColors.secondaryColor,
              spreadRadius: 0.5,
              blurRadius: 3,
              offset: Offset(0, 0), // changes position of shadow
            ),
          ],
        ),
      );
}
