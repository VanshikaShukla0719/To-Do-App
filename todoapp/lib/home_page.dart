import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todoapp/data/database.dart';
import 'package:todoapp/util/dialog_box.dart';
import 'package:todoapp/util/todo_tile.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
  const HomePage({super.key});
}

class _HomePageState extends State<HomePage> {
  //reference the hive box
  final _myBox = Hive.box('mybox');
  ToDoDataBase db = ToDoDataBase();
  @override
  void initState() {
// if is the 1st time ever open in the app, then create default data
    if (_myBox.get("ToDoList") == null) {
      db.createInitialData();
    } else {
      // there is already exits data
      db.loadData();
    }

    super.initState();
  }

  // text Controller
  final _controller = TextEditingController();

  // List of todo tasks
  // List<List<dynamic>> todolist = [
  //   ["Wake Up", false],
  //   ["Do Exercise", false],
  // ];

  // Checkbox was tapped
  void checkboxChanged(bool? value, int index) {
    setState(() {
      db.todolist[index][1] = !(db.todolist[index][1] as bool);
    });
    db.updateDataBase();
  }

  //save new task
  void saveNewTask() {
    setState(() {
      db.todolist.add([_controller.text, false]);
      _controller.clear();
    });
    Navigator.of(context).pop();
    db.updateDataBase();
  }

  // create a new task
  void createNewTask(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return DialogBox(
          controller: _controller,
          onSave: saveNewTask,
          onCancel: () => Navigator.of(context).pop(),
        );
      },
    );
  }
  // void createNewTask() {
  //   showDialog(
  //     context: context,
  //     builder: (context) {
  //       return DialogBox(
  //         Controller: _controller,
  //         onSave: saveNewTask,
  //         oncancel: () => Navigator.of(context).pop(),
  //       );
  //     },
  //   );
  // }

  // delete task
  void deleteTask(int index) {
    setState(() {
      db.todolist.removeAt(index);
    });
    db.updateDataBase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[200],
      appBar: AppBar(
        title: const Text('TO DO'),
        centerTitle: true,
        //toolbarHeight: 50,
        elevation: 0,
        backgroundColor: Colors.blue[500],
      ),

      floatingActionButton: Builder(
        builder: (BuildContext context) {
          return FloatingActionButton(
            onPressed: () => createNewTask(context),
            child: const Icon(Icons.add),
          );
        },
      ),

      // floatingActionButton: FloatingActionButton(
      //   onPressed: createNewTask,
      //   child: Icon(Icons.add),
      // ),

      body: ListView.builder(
        itemCount: db.todolist.length,
        itemBuilder: (context, index) {
          return ToDoTile(
            taskName: db.todolist[index][0] as String,
            taskCompleted: db.todolist[index][1] as bool,
            onChanged: (value) => checkboxChanged(value, index),
            deleteFunction: (context) => deleteTask(index),
          );
        },
      ),
    );
  }
}
