import 'package:flutter/foundation.dart';
import 'task.dart';
import 'dart:collection';
import 'package:shared_preferences/shared_preferences.dart';

class TaskData extends ChangeNotifier {
  TaskData() {
    getTaskString();
  }
  List<Task> _tasks = [
//    Task(name: 'Buy milk'),
//    Task(name: 'Buy eggs'),
//    Task(name: 'Buy breads'),
  ];

  UnmodifiableListView<Task> get tasks {
    return UnmodifiableListView(_tasks);
  }

  int get taskCount {
    return _tasks.length;
  }

  void addTask(String newTaskTitle) {
    final task = Task(name: newTaskTitle);
    _tasks.add(task);
    updateSP();
    notifyListeners();
  }

  void upDateTask(Task task) {
    task.toggleDone();
    updateSP();
    notifyListeners();
  }

  void removeTask(Task task) {
    _tasks.remove(task);
    updateSP();
    notifyListeners();
  }

  void getTaskString() async {
    final prefs = await SharedPreferences.getInstance();
    int num = 0;
    bool goon = true;
    while (goon) {
      String temp = prefs.getString('taskString$num');
      if (temp != null) {
        num++;
      } else {
        goon = false;
      }
    }
    for (int i = 0; i < num; i++) {
      String temp = prefs.getString('taskString$i');
      bool isDone = prefs.getBool('taskDone$i');
      _tasks.add(Task(name: temp, isDone: isDone));
    }
    notifyListeners();
  }

  void updateSP() async {
    final prefs = await SharedPreferences.getInstance();
    int num = 0;
    bool goon = true;
    while (goon) {
      String temp = prefs.getString('taskString$num');
      if (temp != null) {
        num++;
      } else {
        goon = false;
      }
    }
    for (int i = taskCount; i < num; i++) {
      prefs.remove('taskString$i');
      prefs.remove('taskDone$i');
    }
    for (int i = 0; i < taskCount; i++) {
      prefs.setString('taskString$i', _tasks[i].name);
      prefs.setBool('taskDone$i', _tasks[i].isDone);
    }
  }
}
