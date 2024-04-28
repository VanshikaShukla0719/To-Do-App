import 'package:hive_flutter/hive_flutter.dart';

class ToDoDataBase {
  List todolist = [];

//reference the box
  final _myBox = Hive.box('mybox');
// run ths methos if this is 1st time ever opening this app
  void createInitialData() {
    todolist = [
      ["wake up ", false],
      ["do Exercise", false],
    ];
  }
// load the data from DataBase

  void loadData() {
    // Retrieve the data from storage
    var data = _myBox.get("ToDoList");

    // Check if the data is not null before assigning it to todolist
    if (data != null && data is List<dynamic>) {
      // If data is not null and is a List<dynamic>, assign it to todolist
      todolist = data;
    } else {
      // If data is null or not a List<dynamic>, assign an empty list to todolist
      todolist = [];
    }
  }

//update dataBase
  void updateDataBase() {
    _myBox.put("ToDoList", todolist);
  }
}
