import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class TextComposer extends StatefulWidget {
  TextComposer(this.sendMessage );

  final Function({String text, File imgFile}) sendMessage;

  @override
  _TextComposerState createState() => _TextComposerState();
}

class _TextComposerState extends State<TextComposer> {
  final TextEditingController textEditingController = TextEditingController();

  bool _isComposing = false;

  void _reset(){
    textEditingController.clear();
    setState(() {
      _isComposing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: <Widget>[
          IconButton(icon: Icon(Icons.photo_camera), onPressed: () async{
            final picker = ImagePicker();
            final PickedFile pickedFile = await picker.getImage(source: ImageSource.camera);
            if(pickedFile == null) return;
            File imgFile = File(pickedFile.path);
            widget.sendMessage(imgFile: imgFile);
          }),
          Expanded(
              child: TextField(
            controller: textEditingController,
            decoration:
                InputDecoration.collapsed(hintText: "Enviar uma Mensagem"),
            onChanged: (text) {
              setState(() {
                _isComposing = text.isNotEmpty;
              });
            },
            onSubmitted: (text) {
              widget.sendMessage(text: text);
              _reset();
            },
          )),
          IconButton(
            icon: Icon(Icons.send),
            onPressed: _isComposing ? () {
              widget.sendMessage(text : textEditingController.text);
              _reset();
            } : null,
          )
        ],
      ),
    );
  }
}
