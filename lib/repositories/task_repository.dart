import 'dart:convert';

import '../model/task.dart';
import 'package:http/http.dart' as http;

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_material_you/model/task.dart';

class TaskRepository {
  static const _tasksKey = 'tasks';

  Future<List<Task>> getTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final tasksJson = prefs.getString(_tasksKey);
    if (tasksJson != null) {
      final List<dynamic> tasksList = jsonDecode(tasksJson);
      return tasksList.map((taskJson) => Task.fromJson(taskJson)).toList();
    }
    return [];
  }

  Future<void> addTask(Task task) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<Task> tasks = await getTasks();
    tasks.add(task);
    final tasksJson = jsonEncode(tasks.map((task) => task.toJson()).toList());
    prefs.setString(_tasksKey, tasksJson);
  }

  Future<void> updateTask(Task updatedTask) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<Task> tasks = await getTasks();
    final updatedTasks = tasks.map((task) {
      return task.id == updatedTask.id ? updatedTask : task;
    }).toList();
    final tasksJson = jsonEncode(updatedTasks.map((task) => task.toJson()).toList());
    prefs.setString(_tasksKey, tasksJson);
  }
}
