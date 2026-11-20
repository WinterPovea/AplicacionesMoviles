import 'package:flutter/foundation.dart';

import '../data/task_repository.dart';
import '../domain/task.dart';

class TasksViewModel extends ChangeNotifier {
  TasksViewModel(this._repository);

  final TaskRepository _repository;
  List<Task> _tasks = [];
  bool isLoading = false;
  String? errorMessage;

  List<Task> get tasks => List.unmodifiable(_tasks);

  Future<void> loadTasks() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      _tasks = await _repository.getTasks();
    } catch (error) {
      errorMessage = 'No se pudieron cargar las tareas.';
      debugPrint('Error al cargar tareas: $error');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Task? findTask(int? id) {
    if (id == null) return null;
    for (final task in _tasks) {
      if (task.id == id) return task;
    }
    return null;
  }

  void toggleCompleted(int id) {
    final current = findTask(id);
    if (current == null) return;

    final updated = current.copyWith(isCompleted: !current.isCompleted);
    _repository.save(updated);
    _tasks = [
      for (final task in _tasks)
        if (task.id == id) updated else task,
    ];
    notifyListeners();
  }
}
