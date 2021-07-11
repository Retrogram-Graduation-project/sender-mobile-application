import 'dart:ffi';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nearby_connections/nearby_connections.dart';
import 'package:provider/provider.dart';
import 'package:sender_app/helpers/provider.dart';
import 'package:sender_app/models/device.dart';
import 'package:sender_app/styles/style.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  /// Must confirm if there is a connected device or not. [RetroProvider.isConnected]
  // Check for bluetooth.

  bool discovering;
  TextEditingController _textController;
  RetroDevice device;

  @override
  void initState() {
    _textController = TextEditingController();
    discovering = false;
    device = RetroDevice();
    super.initState();
  }

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
        child: SingleChildScrollView(
          child: Column(
            children: [
              Provider.of<RetroProvider>(context, listen: true).isConnected
                  ? connected(context)
                  : notConnected(context),
            ],
          ),
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
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              margin: EdgeInsets.only(top: 60),
              child: Column(
                children: [
                  Text(
                    'No connected',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      letterSpacing: 1.5,
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                  Text(
                    "RetroDevice",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      letterSpacing: 1.5,
                      color: RetroColors.secondaryColor,
                      fontSize: 21,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: discovering
                  ? CircularProgressIndicator()
                  : Text(
                      'Please run the RetroDevice and enable Peer-to-peer service',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        letterSpacing: 2,
                        color: Colors.grey[300].withOpacity(0.9),
                        fontSize: 15,
                      ),
                    ),
            ),
            TextButton(
              // Implement connecting to Bluetooth
              onPressed: _onConnect,
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
          mainAxisAlignment: MainAxisAlignment.spaceAround,
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
              device.name.toUpperCase(),
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
            TextButton(
              // Implement selecting image.
              onPressed: _onSelectAction,
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
          ],
        ),
      );

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

  void _onConnect() async {
    String userName = "This is a sender device.";
    try {
      bool a = await Nearby().startDiscovery(
        userName,
        Strategy.P2P_STAR,
        onEndpointFound: (id, name, serviceId) {
          // show sheet automatically to request connection
          showDialog(
            context: context,
            builder: (builder) {
              return AlertDialog(
                title: Text("Retro Device found!"),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text("id: " + id),
                    Text("Name: " + name),
                    ElevatedButton(
                      child: Text("Request Connection"),
                      onPressed: () {
                        Navigator.pop(context);
                        Nearby().requestConnection(
                          userName,
                          id,
                          onConnectionInitiated: (id, info) {
                            onConnectionInit(id, info);
                            print("onConnectinoInitiaited");
                          },
                          onConnectionResult: (id, status) {
                            showSnackbar(status);
                            if (status == Status.CONNECTED) {
                              setState(() {
                                device.name = name;
                                device.id = id;
                                var provider = Provider.of<RetroProvider>(
                                    context,
                                    listen: false);
                                provider.isConnected = true;
                                provider.deviceName = device.name;
                                discovering = false;
                              });
                              Nearby().stopDiscovery();
                            }
                          },
                          onDisconnected: (id) {
                            showSnackbar("Disconnected from: $id, id $id");
                            setState(() {
                              Provider.of<RetroProvider>(context, listen: false)
                                  .isConnected = false;
                            });
                          },
                        );
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
        onEndpointLost: (id) {
          showSnackbar("Lost discovered Endpoint: $id, id $id");
        },
      );
      showSnackbar("DISCOVERING: " + a.toString());
      setState(() {
        discovering = a;
      });
    } catch (e) {
      showSnackbar("Already discovering");
    }
  }

  void onConnectionInit(String id, ConnectionInfo info) {
    showDialog(
      context: context,
      builder: (builder) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text("id: " + id),
              Text("Token: " + info.authenticationToken),
              Text("Name: " + info.endpointName),
              SizedBox(height: 5),
              ElevatedButton(
                child: Text("Accept Connection"),
                onPressed: () {
                  Navigator.pop(context);
                  setState(() {
                    device.info = info;
                    device.id = id;
                  });
                  Nearby().acceptConnection(
                    id,
                    onPayLoadRecieved: null,
                    onPayloadTransferUpdate: (endid, payloadTransferUpdate) {
                      if (payloadTransferUpdate.status ==
                          PayloadStatus.IN_PROGRESS) {
                        print(payloadTransferUpdate.bytesTransferred);
                      } else if (payloadTransferUpdate.status ==
                          PayloadStatus.FAILURE) {
                        print("failed");
                        showSnackbar(endid + ": FAILED to transfer file");
                      } else if (payloadTransferUpdate.status ==
                          PayloadStatus.SUCCESS) {
                        showSnackbar(
                            "$endid success, total bytes = ${payloadTransferUpdate.totalBytes}");
                      }
                    },
                  );
                },
              ),
              ElevatedButton(
                child: Text("Reject Connection"),
                onPressed: () async {
                  Navigator.pop(context);
                  try {
                    await Nearby().rejectConnection(id);
                  } catch (e) {
                    showSnackbar(e);
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _onSelectAction() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Please select an action"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 40,
                child: TextButton(
                  onPressed: _selectText,
                  child: Text(
                    "Text",
                    style: TextStyle(color: RetroColors.secondaryColor),
                  ),
                ),
              ),
              Divider(),
              SizedBox(
                height: 40,
                child: TextButton(
                  onPressed: _selectImage,
                  child: Text(
                    "Image",
                    style: TextStyle(color: RetroColors.secondaryColor),
                  ),
                ),
              ),
              Divider(),
              SizedBox(
                height: 40,
                child: TextButton(
                  onPressed: _selectDraw,
                  child: Text(
                    "Draw",
                    style: TextStyle(color: RetroColors.secondaryColor),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _selectText() {
    Navigator.of(context).pop();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Type words to be sent"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _textController,
                  onSubmitted: (String value) {
                    Nearby().sendBytesPayload(
                        device.id, Uint8List.fromList(value.codeUnits));
                    _textController.text = "";
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _selectImage() async {
    Navigator.of(context).pop();

    PickedFile file = await ImagePicker().getImage(source: ImageSource.gallery);
    if (file == null) return;
    int payloadId = await Nearby().sendFilePayload(device.id, file.path);
    showSnackbar("Sending file to ${device.name}");
    Nearby().sendBytesPayload(
        device.id,
        Uint8List.fromList(
            "$payloadId:${file.path.split('/').last}".codeUnits));
  }

  void _selectDraw() {}

  void showSnackbar(dynamic a) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(a.toString()),
    ));
  }
}
