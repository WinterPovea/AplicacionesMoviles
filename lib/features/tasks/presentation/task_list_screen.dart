import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'tasks_view_model.dart';

class TaskListScreen extends StatelessWidget {
  const TaskListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<TasksViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis tareas'),
        actions: [
          IconButton(
            tooltip: 'Actualizar tareas',
            onPressed: viewModel.isLoading
                ? null
                : () => context.read<TasksViewModel>().loadTasks(),
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: _buildBody(context, viewModel),
    );
  }

  Widget _buildBody(BuildContext context, TasksViewModel viewModel) {
    if (viewModel.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (viewModel.errorMessage != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(viewModel.errorMessage!),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => context.read<TasksViewModel>().loadTasks(),
              child: const Text('Reintentar'),
            ),
          ],
        ),
      );
    }
    if (viewModel.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Todavía no hay tareas para mostrar.'),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => context.read<TasksViewModel>().loadTasks(),
              child: const Text('Actualizar'),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => context.read<TasksViewModel>().loadTasks(),
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        itemCount: viewModel.tasks.length,
        itemBuilder: (context, index) {
          final task = viewModel.tasks[index];
          return Card(
            child: ListTile(
              leading: Icon(
                task.isCompleted
                    ? Icons.check_circle
                    : Icons.radio_button_unchecked,
              ),
              title: Text(task.title),
              subtitle: Text('Prioridad: ${task.priority}'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.push('/task/${task.id}'),
            ),
          );
        },
      ),
    );
  }
}
