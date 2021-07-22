import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:nearby_connections/nearby_connections.dart';
import 'package:photo_view/photo_view.dart';
import 'package:provider/provider.dart';
import 'package:sender_app/helpers/provider.dart';

class ImagePage extends StatefulWidget {
  final String path;
  ImagePage({this.path});
  @override
  _ImagePageState createState() => _ImagePageState();
}

const double min = pi * -2;
const double max = pi * 2;

const double minScale = 0.03;
const double defScale = 0.1;
const double maxScale = 0.6;

class _ImagePageState extends State<ImagePage> {
  PhotoViewControllerBase controller;
  PhotoViewScaleStateController scaleStateController;

  RetroProvider provider;
  int calls = 0;

  @override
  void initState() {
    provider = Provider.of<RetroProvider>(context, listen: false);
    controller = PhotoViewController(initialScale: defScale)
      ..outputStateStream.listen(onController);

    scaleStateController = PhotoViewScaleStateController()
      ..outputScaleStateStream.listen(onScaleState);
    super.initState();
  }

  void onController(PhotoViewControllerValue value) {
    setState(() {
      calls += 1;
    });
  }

  void onScaleState(PhotoViewScaleState scaleState) {
    print(scaleState);
    double newScale, newRotation = 0;

    if (scaleState == PhotoViewScaleState.initial)
      newScale = 0.045;
    else if (scaleState == PhotoViewScaleState.covering) newScale = maxScale;
    Nearby().sendBytesPayload(
        provider.device.id, Uint8List.fromList("s45:$newScale".codeUnits));
    Nearby().sendBytesPayload(
        provider.device.id, Uint8List.fromList("r45:$newRotation".codeUnits));
  }

  @override
  void dispose() {
    controller.dispose();
    scaleStateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ClipRect(
        child: Stack(
          children: <Widget>[
            Positioned.fill(
              child: PhotoView(
                imageProvider: FileImage(File(widget.path)),
                controller: controller,
                scaleStateController: scaleStateController,
                enableRotation: true,
                initialScale: minScale * 1.5,
                minScale: minScale,
                maxScale: maxScale,
              ),
            ),
            Positioned(
              bottom: 0,
              height: 290,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(30.0),
                child: StreamBuilder(
                  stream: controller.outputStateStream,
                  initialData: controller.value,
                  builder: _streamBuild,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _streamBuild(BuildContext context, AsyncSnapshot snapshot) {
    if (snapshot.hasError || !snapshot.hasData) {
      return Container();
    }
    final PhotoViewControllerValue value = snapshot.data;
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Text(
          "Rotation ${value.rotation}",
          style: const TextStyle(color: Colors.white),
        ),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: Colors.orange,
            thumbColor: Colors.orange,
          ),
          child: Slider(
            value: value.rotation.clamp(min, max),
            min: min,
            max: max,
            onChanged: (double newRotation) {
              controller.rotation = newRotation;
              Nearby().sendBytesPayload(provider.device.id,
                  Uint8List.fromList("r45:${controller.rotation}".codeUnits));
            },
          ),
        ),
        Text(
          "Scale ${value.scale}",
          style: const TextStyle(color: Colors.white),
        ),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: Colors.orange,
            thumbColor: Colors.orange,
          ),
          child: Slider(
            value: value.scale.clamp(minScale, maxScale),
            min: minScale,
            max: maxScale,
            onChanged: (double newScale) {
              controller.scale = newScale;
              Nearby().sendBytesPayload(provider.device.id,
                  Uint8List.fromList("s45:${controller.scale}".codeUnits));
            },
          ),
        ),
      ],
    );
  }
}
