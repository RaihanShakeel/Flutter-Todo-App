//import 'dart:ui';

import 'package:flutter/material.dart';
import "package:hive_flutter/hive_flutter.dart";
import 'package:taskly/models/task.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late double _deviceHeight; //_deviceWidth;
  String? _newTaskValue;
  Box? _box;
  _MyHomePageState();
  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    //_deviceWidth = MediaQuery.of(context).size.width;
    return  Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        toolbarHeight: _deviceHeight * 0.15,
        title: const Text(
          "Taskly!",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 32,
            color: Colors.white,
          ),
        ),
      ),
      body: _taskView(),
      floatingActionButton: _addTaskButton(),
    );
  }

  Widget _taskView(){
    return FutureBuilder(
      future: Hive.openBox('tasks'),
      builder: (BuildContext context, AsyncSnapshot snapshot){
        if (snapshot.hasData){
          _box = snapshot.data;
          return _taskList();
        }
        else{
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Widget _taskList(){
    List tasks = _box!.values.toList();
    return ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (BuildContext context, int index) {
        var task = Task.fromMap(tasks[index]);
        return ListTile(
          title: Text(
            task.title,
            style: TextStyle(
              fontSize: 20,
              decoration: task.done? TextDecoration.lineThrough: null,
            ),
          ),
          subtitle: Text(
            task.timeStamp.toString(),
          ),
          trailing: Icon(
            task.done? Icons.check_box_outlined: Icons.check_box_outline_blank,
            color: Colors.red,
          ),
          onTap: (){
            task.done = !task.done;
            _box!.putAt(index, task.toMap());
            setState(() {});
          },

        onLongPress: () {
          var key = _box!.keyAt(index);
          _box!.delete(key);
          setState(() {});
        },
        );
      },
    );
  }

  Widget _addTaskButton(){
    return FloatingActionButton(
      backgroundColor: Colors.red,
      onPressed: _displayTaskPopup,
      child: const Icon(
        Icons.add,
        color: Colors.white,
      ),
      
      );
  }

  void _displayTaskPopup(){
    showDialog(
      context: context,
      builder: (BuildContext context){
        return  AlertDialog(
          title: const Text("Add new task!"),
          content: TextField(
            onSubmitted: (_) {
              if(_newTaskValue != null){
                Task newTask = Task(
                  title: _newTaskValue!,
                  timeStamp: DateTime.now(),
                  done: false,
                );
                _box?.add(newTask.toMap());
                setState(() {
                  _newTaskValue = null;
                  Navigator.pop(context);
                });
              }
            },
            onChanged: (value) {
              setState(() {
                _newTaskValue = value;
              });
            },
          ),
        );
      }
    );
  }
}