import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app/taskflow_app.dart';
import 'features/tasks/data/remote_task_repository.dart';
import 'features/tasks/data/task_api_service.dart';
import 'features/tasks/data/task_repository.dart';
import 'features/tasks/presentation/tasks_view_model.dart';

void main() {
  final TaskRepository repository = RemoteTaskRepository(TaskApiService());

  runApp(
    ChangeNotifierProvider<TasksViewModel>(
      create: (_) => TasksViewModel(repository)..loadTasks(),
      child: const TaskFlowApp(),
    ),
  );
}
