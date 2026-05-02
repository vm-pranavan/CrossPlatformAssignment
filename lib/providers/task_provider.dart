import 'package:flutter/material.dart';
import '../models/task_model.dart';
import '../services/parse_service.dart';

class TaskProvider extends ChangeNotifier {
  final ParseService _parseService = ParseService();
  List<TaskModel> _tasks = [];
  bool _isLoading = false;

  List<TaskModel> get tasks => _tasks;
  bool get isLoading => _isLoading;

  Future<void> fetchTasks() async {
    _setLoading(true);
    try {
      _tasks = await _parseService.getTasks();
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  Future<String?> addTask(String title, String description) async {
    final response = await _parseService.saveTask(title, description);
    if (response.success) {
      await fetchTasks();
      return null;
    } else {
      return response.error?.message ?? 'Failed to add task';
    }
  }

  Future<String?> updateTask(TaskModel task) async {
    final response = await _parseService.updateTask(task);
    if (response.success) {
      notifyListeners();
      return null;
    } else {
      return response.error?.message ?? 'Failed to update task';
    }
  }

  Future<String?> deleteTask(TaskModel task) async {
    final response = await _parseService.deleteTask(task);
    if (response.success) {
      _tasks.removeWhere((t) => t.objectId == task.objectId);
      notifyListeners();
      return null;
    } else {
      return response.error?.message ?? 'Failed to delete task';
    }
  }

  Future<void> toggleTaskStatus(TaskModel task) async {
    task.isCompleted = !task.isCompleted;
    await updateTask(task);
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
