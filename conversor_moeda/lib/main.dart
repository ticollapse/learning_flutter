import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

const request = "https://api.hgbrasil.com/finance?format=json&key=02ae492a";

void main() async {
  runApp(MaterialApp(
    home: Home(),
    theme: ThemeData(
        hintColor: Colors.amber,
        primaryColor: Colors.white,
        inputDecorationTheme: InputDecorationTheme(
          enabledBorder:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
          focusedBorder:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.amber)),
          hintStyle: TextStyle(color: Colors.amber),
        )),
  ));
}

Future<Map> getData() async {
  http.Response response = await http.get(request);
  return json.decode(response.body);
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  final realController = TextEditingController();
  final dolarController = TextEditingController();
  final euroController = TextEditingController();


  double dolar;
  double euro;

  void _resetField(){
    realController.text = "";
    dolarController.text = "";
    euroController.text = "";
  }

  double _textFieldValidate(String text){
      if(text.isEmpty){
        _resetField();
        return null;
      }
      text = text.replaceAll(",", ".");
      return double.parse(text);
  }

  void _realChanged(String text){
    double value = _textFieldValidate(text);
    dolarController.text = (value/dolar).toStringAsFixed(2);
    euroController.text = (value/euro).toStringAsFixed(2);
  }

  void _dolarChanged(String text){
    double value = _textFieldValidate(text);
    realController.text = (this.dolar * value).toStringAsFixed(2);
    euroController.text = (this.dolar * value / euro).toStringAsFixed(2);
  }

  void _euroChanged(String text){
    double value = _textFieldValidate(text);
    realController.text = (this.euro * value).toStringAsFixed(2);
    dolarController.text = (this.euro * value / dolar).toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("\$ Conversor \$"),
        backgroundColor: Colors.amber,
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _resetField,
          ),
        ],
      ),
      body: FutureBuilder<Map>(
        future: getData(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return null;
              break;
            case ConnectionState.waiting:
              return Center(
                  child: Text(
                "Carregando Dados...",
                style: TextStyle(color: Colors.amber, fontSize: 25),
                textAlign: TextAlign.center,
              ));
              break;
            default:
              if (snapshot.hasError) {
                return Center(
                    child: Text(
                  "Erro ao Carregar os Dados :/",
                  style: TextStyle(color: Colors.amber, fontSize: 25),
                  textAlign: TextAlign.center,
                ));
              } else {
                dolar = snapshot.data['results']['currencies']['USD']['buy'];
                euro = snapshot.data['results']['currencies']['EUR']['buy'];
                return SingleChildScrollView(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Icon(Icons.monetization_on,
                          size: 150, color: Colors.amber),
                      Divider(),
                      buildTextField("Real","R\$ ",realController,_realChanged),
                      Divider(),
                      buildTextField("Dólar","US ",dolarController,_dolarChanged),
                      Divider(),
                      buildTextField("Euro","€ ",euroController,_euroChanged),
                    ],
                  ),
                );
              }
          }
        },
      ),
    );
  }
}


buildTextField(String label, String prefix, TextEditingController controller, Function onTextChanged){
  return TextField(
    controller: controller,
    decoration: InputDecoration(
        labelText: "$label",
        labelStyle: TextStyle(color: Colors.amber),
        border: OutlineInputBorder(),
        prefixText: "$prefix"),
    style: TextStyle(color: Colors.amber, fontSize: 25),
    onChanged: onTextChanged,
    keyboardType: TextInputType.number,
  );
}