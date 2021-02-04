import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(MaterialApp(home: Home()));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List _toDoList = [];

  final _toDoController = TextEditingController();
  final _selectedDateController = TextEditingController();

  Map<String, dynamic> _lastRemoved;
  int _lastRemovedPos;

  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();

    _readData().then((data) {
      setState(() {
        _toDoList = json.decode(data);
      });
    });
  }

  void _add_ToDo() {
    setState(() {
      Map<String, dynamic> newToDo = Map();
      newToDo["title"] = _toDoController.text;
      _toDoController.text = "";
      newToDo["ok"] = false;
      newToDo["date"] = "${_selectedDate.day.toString().padLeft(2,'0')}/${_selectedDate.month.toString().padLeft(2,'0')}/${_selectedDate.year}";
      _toDoList.add(newToDo);
      _saveData();
    });
  }

  Future<Null> _refreshList() async {
    await Future.delayed(Duration(seconds: 1));
    setState(() {
      _toDoList.sort((a, b) {
        print("Entrou");
        DateTime dateA = DateFormat('dd/MM/yyyy').parseLoose(a["date"]);
        DateTime dateB = DateFormat('dd/MM/yyyy').parseLoose(b["date"]);
        print("Ola");
        if (dateA.isBefore(dateB) && !(a["ok"] && !b["ok"])  )
          return -1;
        else if (dateA.isBefore(dateB))
          return 1;
        else if (dateB.isBefore(dateA) && !(b["ok"] && !a["ok"]) )
          return 1;
        else if (dateB.isBefore(dateA))
          return -1;
        else
          return 0;
      });
    });
  }

  Widget buildItem(BuildContext context, int index) {
    return Dismissible(
      background: Container(
        color: Colors.red,
        child: Align(
          alignment: Alignment(-0.9, 0),
          child: Icon(
            Icons.delete,
            color: Colors.white,
          ),
        ),
      ),
      direction: DismissDirection.startToEnd,
      child: CheckboxListTile(
        title: Text("${_toDoList[index]["title"]} - ${_toDoList[index]["date"]}" ),
        value: _toDoList[index]["ok"],
        secondary: CircleAvatar(
            child: Icon(_toDoList[index]["ok"] ? Icons.check : Icons.error)),
        onChanged: (bool) {
          setState(() {
            _toDoList[index]["ok"] = bool;
            _saveData();
          });
        },
      ),
      key: Key(DateTime.now().microsecond.toString()),
      onDismissed: (direction) {
        setState(() {
          _lastRemoved = Map.from(_toDoList[index]);
          _lastRemovedPos = index;
          _toDoList.removeAt(index);

          _saveData();

          final snack = SnackBar(
            content: Text("Tarefa \"${_lastRemoved["title"]}\" removida!"),
            action: SnackBarAction(
              label: "Desfazer",
              onPressed: () {
                setState(() {
                  _toDoList.insert(_lastRemovedPos, _lastRemoved);
                });
              },
            ),
            duration: Duration(seconds: 2),
          );
          Scaffold.of(context).removeCurrentSnackBar();
          Scaffold.of(context).showSnackBar(snack);
        });
      },
    );
  }

  Future<File> _getFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File("${directory.path}/data.json");
  }

  Future<File> _saveData() async {
    String data = json.encode(_toDoList);
    final file = await _getFile();
    return file.writeAsString(data);
  }

  Future<String> _readData() async {
    try {
      final file = await _getFile();
      return file.readAsString();
    } catch (e) {
      return null;
    }
  }

  Future<void> _popUpCreateTask() async {
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, setState) {
            return SimpleDialog(
              // title: Align(
              //   alignment: Alignment(0, 0),
              //   child: Text('Descreva a tarefa'),
              // ),
              title: null,
              children: <Widget>[
                Container(
                    padding: EdgeInsets.fromLTRB(17, 1, 10, 0),
                    child: Column(
                      children: <Widget>[
                        TextField(
                          controller: _toDoController,
                          decoration: InputDecoration(
                              labelText: "Nova Tarefa",
                              labelStyle: TextStyle(color: Colors.blueAccent)),
                          autofocus: true,
                        ),
                        Align(
                          alignment: Alignment(-0.9, 0),
                          child: Padding(
                            padding: EdgeInsets.only(top: 15),
                            child: GestureDetector(
                              child: Text(
                                "Selecionar Data: ${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}",
                                style: TextStyle(fontSize: 17),
                              ),
                              onTap: () {
                                showDatePicker(
                                  context: context,
                                  initialDate: _selectedDate,
                                  // Refer step 1
                                  firstDate: DateTime(2000),
                                  lastDate: DateTime(2025),
                                ).then((value) {
                                  if (value != null && value != _selectedDate)
                                    setState(() {
                                      _selectedDate = value;
                                    });
                                });
                              },
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment(0, 0),
                          child: Padding(
                            padding: EdgeInsets.only(top: 5),
                            child: RaisedButton(
                              color: Colors.blueAccent,
                              child: Text("Salvar"),
                              textColor: Colors.white,
                              onPressed: () {
                                _add_ToDo();
                                Navigator.pop(context);
                              },
                            ),
                          ),
                        )
                      ],
                    )),
              ],
            );
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Lista de Tarefas"),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Container(
          //   padding: EdgeInsets.fromLTRB(17, 1, 7, 1),
          //   child: Row(
          //     children: [
          //       Expanded(
          //           child: TextField(
          //         controller: _toDoController,
          //         decoration: InputDecoration(
          //             labelText: "Nova Tarefa",
          //             labelStyle: TextStyle(color: Colors.blueAccent)),
          //       )),
          //       RaisedButton(
          //         color: Colors.blueAccent,
          //         child: Text("Add"),
          //         textColor: Colors.white,
          //         onPressed: _add_ToDo,
          //       )
          //     ],
          //   ),
          // ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _refreshList,
              child: ListView.builder(
                  padding: EdgeInsets.only(top: 10),
                  itemCount: _toDoList.length,
                  itemBuilder: buildItem),
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _popUpCreateTask,
        tooltip: 'Adicionar Tarefa',
        child: Icon(Icons.add),
        backgroundColor: Colors.green,
      ),
    );
  }
}
