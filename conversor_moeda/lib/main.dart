import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:async/async.dart';
import 'dart:convert';

const request = "https://api.hgbrasil.com/finance?format=json&key=02ae492a";

void main() async{

  http.Response response = await http.get(request);
  print(response);
  json.decode(response.body)

  runApp(MaterialApp(
    home: Container()
  ));
}