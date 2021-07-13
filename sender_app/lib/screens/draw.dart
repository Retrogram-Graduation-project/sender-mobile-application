import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:nearby_connections/nearby_connections.dart';
import 'package:provider/provider.dart';
import 'package:sender_app/helpers/provider.dart';

class DrawingArea {
  Offset point;
  Paint areaPaint;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> ret = {};
    Map<String, String> p = {
      '"direction"': '"${point.direction.toString()}"',
      '"distance"': '"${point.distance.toString()}"',
      '"distanceSquared"': '"${point.distanceSquared.toString()}"',
      '"dx"': '"${point.dx.toString()}"',
      '"dy"': '"${point.dy.toString()}"',
      '"isFinite"': '"${point.isFinite.toString()}"',
      '"isInfinite"': '"${point.isInfinite.toString()}"',
    };

    Map<String, String> a = {
      '"color"': '"${areaPaint.color.toString()}"',
      '"strokeWidth"': '"${areaPaint.strokeWidth.toString()}"',
    };
    ret['"point"'] = p;
    ret['"areaPaint"'] = a;
    return ret;
  }

  DrawingArea({this.point, this.areaPaint});
}

class DrawPage extends StatefulWidget {
  @override
  _DrawPageState createState() => _DrawPageState();
}

class _DrawPageState extends State<DrawPage> {
  List<DrawingArea> points;
  Color selectedColor;
  Color previousColor;
  double strokeWidth;

  @override
  void initState() {
    super.initState();
    selectedColor = Colors.black;
    previousColor = Colors.black;
    strokeWidth = 2.0;
    points = [];
  }

  void selectColor() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Color Chooser'),
          content: SingleChildScrollView(
            child: BlockPicker(
              pickerColor: selectedColor,
              onColorChanged: (color) {
                this.setState(() {
                  if (selectedColor != Colors.white)
                    previousColor = selectedColor;
                  selectedColor = color;
                });
              },
            ),
          ),
          actions: <Widget>[
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("Close"))
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      String bytes = "p45:\n";

      for (int i = 0; i < points.length; i++) {
        if (points[i] == null)
          bytes += "null";
        else
          bytes += (points[i].toJson().toString());
        if (i != points.length - 1) bytes += '\n';
      }

      if (bytes.split('\n').length > 1)
        Nearby().sendBytesPayload(
            Provider.of<RetroProvider>(context, listen: false).device.id,
            Uint8List.fromList(bytes.codeUnits));
    });
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    print("build function");

    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                  Color.fromRGBO(138, 35, 135, 1.0),
                  Color.fromRGBO(233, 64, 87, 1.0),
                  Color.fromRGBO(242, 113, 33, 1.0),
                ])),
          ),
          Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: width * 0.80,
                    height: height * 0.80,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.4),
                            blurRadius: 5.0,
                            spreadRadius: 1.0,
                          )
                        ]),
                    child: GestureDetector(
                      onPanDown: (details) {
                        this.setState(() {
                          points.add(DrawingArea(
                              point: details.localPosition,
                              areaPaint: Paint()
                                ..strokeCap = StrokeCap.round
                                ..isAntiAlias = true
                                ..color = selectedColor
                                ..strokeWidth = strokeWidth));
                        });
                      },
                      onPanUpdate: (details) {
                        this.setState(() {
                          points.add(DrawingArea(
                              point: details.localPosition,
                              areaPaint: Paint()
                                ..strokeCap = StrokeCap.round
                                ..isAntiAlias = true
                                ..color = selectedColor
                                ..strokeWidth = strokeWidth));
                        });
                      },
                      onPanEnd: (details) {
                        this.setState(() {
                          points.add(null);
                        });
                      },
                      child: SizedBox.expand(
                        child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(20.0)),
                          child: CustomPaint(
                            painter: MyCustomPainter(points: points),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  width: width * 0.80,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(20.0))),
                  child: Row(
                    children: <Widget>[
                      IconButton(
                          icon: Icon(
                            Icons.color_lens,
                            color: selectedColor == Colors.white
                                ? previousColor
                                : selectedColor,
                          ),
                          onPressed: () {
                            selectColor();
                          }),
                      IconButton(
                          icon: Icon(
                            Icons.delete_sweep_rounded,
                            color: selectedColor == Colors.white
                                ? previousColor
                                : selectedColor,
                          ),
                          onPressed: () {
                            this.setState(() {
                              if (selectedColor != Colors.white)
                                previousColor = selectedColor;
                              selectedColor = Colors.white;
                            });
                          }),
                      Expanded(
                        child: Slider(
                          min: 1.0,
                          max: 5.0,
                          label: "Stroke $strokeWidth",
                          activeColor: selectedColor == Colors.white
                              ? previousColor
                              : selectedColor,
                          value: strokeWidth,
                          onChanged: (double value) {
                            this.setState(() {
                              strokeWidth = value;
                            });
                          },
                        ),
                      ),
                      IconButton(
                          icon: Icon(
                            Icons.layers_clear,
                            color: Colors.black,
                          ),
                          onPressed: () {
                            this.setState(() {
                              points.clear();
                            });
                          }),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MyCustomPainter extends CustomPainter {
  List<DrawingArea> points;

  MyCustomPainter({@required this.points});

  @override
  void paint(Canvas canvas, Size size) {
    Paint background = Paint()..color = Colors.white;
    Rect rect = Rect.fromLTWH(0, 0, size.width, size.height);
    canvas.drawRect(rect, background);
    canvas.clipRect(rect);
    print("Paint");
    for (int x = 0; x < points.length - 1; x++) {
      if (points[x] != null && points[x + 1] != null) {
        canvas.drawLine(
            points[x].point, points[x + 1].point, points[x].areaPaint);
      } else if (points[x] != null && points[x + 1] == null) {
        canvas.drawPoints(
            PointMode.points, [points[x].point], points[x].areaPaint);
      }
    }
  }

  @override
  bool shouldRepaint(MyCustomPainter oldDelegate) => true;
}
