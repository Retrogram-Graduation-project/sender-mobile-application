import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:nearby_connections/nearby_connections.dart';
import 'package:provider/provider.dart';
import 'package:sender_app/helpers/provider.dart';

class TextPage extends StatefulWidget {
  const TextPage({Key key}) : super(key: key);

  @override
  _TextPageState createState() => _TextPageState();
}

class _TextPageState extends State<TextPage> {
  int fontSize;
  String text;
  Color selectedColor;
  TextEditingController _textController;

  @override
  void initState() {
    fontSize = 12;
    selectedColor = Colors.white;
    text = "Click anywhere to write";
    _textController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _selectText,
      child: Scaffold(
          backgroundColor: Colors.black,
          body: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    text,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: fontSize.toDouble(),
                      color: selectedColor,
                    ),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Text(
                      "Size $fontSize",
                      style: const TextStyle(color: Colors.white),
                    ),
                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        activeTrackColor: selectedColor,
                        thumbColor: selectedColor,
                      ),
                      child: Slider(
                        value: double.parse(fontSize.toString()),
                        min: 10,
                        max: 100,
                        onChanged: (double newSize) {
                          setState(() {
                            fontSize = newSize.floor();
                          });
                        },
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.color_lens,
                        color: selectedColor,
                      ),
                      onPressed: () {
                        selectColor();
                      },
                    ),
                  ],
                ),
              ],
            ),
          )),
    );
  }

  void _selectText() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Type words to be sent"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(controller: _textController),
                SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      child: Text("Close"),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    TextButton(
                      child: Text("Send"),
                      onPressed: () {
                        if (_textController.text.isEmpty) return;
                        this.setState(() {
                          text = _textController.text;
                        });
                        Navigator.of(context).pop();
                        // Nearby().sendBytesPayload(
                        //     Provider.of<RetroProvider>(context).device.id,
                        //     Uint8List.fromList(
                        //         ("t45:" + _textController.text).codeUnits));
                        // _textController.text = "";
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
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
                if (color != Colors.black)
                  this.setState(() {
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
}
