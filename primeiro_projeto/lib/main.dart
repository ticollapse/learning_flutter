import 'package:flutter/material.dart';

void main() {
  runApp(new MaterialApp(title: "Contador de Pessoas", home: Home()));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _people = 0;
  String _infoText = "Pode Entrar";

  void _changePeople(int delta) {
    setState(() {
      _people += delta;
      if(_people<0){
        _infoText = "Entre de ré";
      }else if(_people <= 10){
        _infoText = "Entra ae mermao";
      }else{
        _infoText = "Lotou mano!";
      }
    });

  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Image.asset(
          "images/restaurant.jpg",
          fit: BoxFit.cover,
          height: 1000,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("Pessoas: $_people",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 25)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                    padding: EdgeInsets.all(10),
                    child: FlatButton(
                        onPressed: () {
                          _changePeople(-1);
                        },
                        child: Text("-1",
                            style:
                                TextStyle(fontSize: 40, color: Colors.white)))),
                Padding(
                    padding: EdgeInsets.all(10),
                    child: FlatButton(
                        onPressed: () {
                          _changePeople(1);
                        },
                        child: Text("+1",
                            style:
                                TextStyle(fontSize: 40, color: Colors.white)))),
              ],
            ),
            Text(_infoText,
                style: TextStyle(
                    color: Colors.white,
                    fontStyle: FontStyle.italic,
                    fontSize: 40)),
          ],
        )
      ],
    );
  }
}
