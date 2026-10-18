import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/task.dart';
import 'local_json_storage.dart';

class TaskData {
  const TaskData._();

  static Future<List<Task>> loadTasks() async {
    final saved = await LocalJsonStorage.read('tasks');
    final text = saved ?? await rootBundle.loadString('assets/data/tasks.json');
    final decoded = jsonDecode(text) as List<dynamic>;
    final tasks = decoded
        .map((item) => Task.fromJson(item as Map<String, dynamic>))
        .toList();
    if (saved == null) await saveTasks(tasks);
    return tasks;
  }

  static Future<void> saveTasks(List<Task> tasks) => LocalJsonStorage.write(
    'tasks',
    jsonEncode(tasks.map((task) => task.toJson()).toList()),
  );
}
