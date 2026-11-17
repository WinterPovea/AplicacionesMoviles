import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'task.dart';

void main() {
  runApp(const TaskFlowApp());
}

const demoTasks = <Task>[
  Task(
    id: 101,
    title: 'Configurar repositorio Git',
    description:
        'Inicializar rama principal y subir estructura base de Flutter',
    priority: 'Alta',
    isCompleted: true,
    userId: 1,
  ),
  Task(
    id: 102,
    title: 'Definir modelo Task y JSON',
    description:
        'Implementar constructor const y factory fromJson en task.dart',
    priority: 'Alta',
    isCompleted: true,
    userId: 1,
  ),
  Task(
    id: 103,
    title: 'Implementar listado con GoRouter',
    description: 'Configurar rutas / y /task/:id con parámetros dinámicos',
    priority: 'Media',
    isCompleted: false,
    userId: 1,
  ),
  Task(
    id: 104,
    title: 'Redactar especificación en README',
    description: 'Documentar historias de usuario, criterios y contratos API',
    priority: 'Media',
    isCompleted: false,
    userId: 1,
  ),
  Task(
    id: 105,
    title: 'Preparar formulario de creación',
    description:
        'Maquetar campos de título, descripción y selector de prioridad',
    priority: 'Baja',
    isCompleted: false,
    userId: 1,
  ),
];

Task? findTask(int? id) {
  for (final task in demoTasks) {
    if (task.id == id) return task;
  }
  return null;
}

final appRouter = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (context, state) => const TaskListScreen()),
    GoRoute(
      path: '/task/:id',
      builder: (context, state) {
        final id = int.tryParse(state.pathParameters['id'] ?? '');
        return TaskDetailScreen(task: findTask(id));
      },
    ),
  ],
);

class TaskFlowApp extends StatelessWidget {
  const TaskFlowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'TaskFlow',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      routerConfig: appRouter,
    );
  }
}

class TaskListScreen extends StatelessWidget {
  const TaskListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mis tareas'), centerTitle: true),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: demoTasks.length,
        itemBuilder: (context, index) {
          final task = demoTasks[index];
          return TaskCard(
            task: task,
            onTap: () => context.push('/task/${task.id}'),
          );
        },
      ),
    );
  }
}

class TaskCard extends StatelessWidget {
  const TaskCard({super.key, required this.task, this.onTap});

  final Task task;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        onTap: onTap,
        leading: Icon(
          task.isCompleted ? Icons.check_circle : Icons.radio_button_unchecked,
          color: task.isCompleted ? Colors.green : Colors.grey,
        ),
        title: Text(
          task.title,
          style: TextStyle(
            decoration: task.isCompleted ? TextDecoration.lineThrough : null,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text('${task.priority} · ${task.description}'),
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }
}

class TaskDetailScreen extends StatelessWidget {
  const TaskDetailScreen({super.key, required this.task});

  final Task? task;

  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'Alta':
        return Colors.red.shade700;
      case 'Media':
        return Colors.amber.shade800;
      default:
        return Colors.blueGrey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final selected = task;
    return Scaffold(
      appBar: AppBar(title: const Text('Detalle de tarea'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: selected == null
            ? Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.search_off, size: 48, color: Colors.grey),
                    const SizedBox(height: 12),
                    const Text('No se encontró esta tarea.'),
                    const SizedBox(height: 24),
                    FilledButton.tonalIcon(
                      onPressed: () => context.pop(),
                      icon: const Icon(Icons.arrow_back),
                      label: const Text('Volver al listado'),
                    ),
                  ],
                ),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: selected.isCompleted
                          ? Colors.green.withAlpha(25)
                          : Colors.amber.withAlpha(25),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: selected.isCompleted
                            ? Colors.green
                            : Colors.amber.shade800,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          selected.isCompleted
                              ? Icons.check_circle
                              : Icons.pending,
                          color: selected.isCompleted
                              ? Colors.green
                              : Colors.amber.shade800,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          selected.isCompleted
                              ? 'Tarea Finalizada'
                              : 'Tarea en Progreso',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: selected.isCompleted
                                ? Colors.green.shade900
                                : Colors.amber.shade900,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    selected.title,
                    style: Theme.of(context).textTheme.headlineSmall
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    selected.description,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 20),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      Chip(
                        avatar: const Icon(Icons.flag, size: 16),
                        label: Text('Prioridad: ${selected.priority}'),
                        backgroundColor: _getPriorityColor(selected.priority)
                            .withAlpha(25),
                      ),
                      Chip(
                        avatar: const Icon(Icons.person, size: 16),
                        label: Text('Usuario #${selected.userId}'),
                      ),
                      Chip(label: Text('ID #${selected.id}')),
                    ],
                  ),
                  const Spacer(),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.tonalIcon(
                      onPressed: () => context.pop(),
                      icon: const Icon(Icons.arrow_back),
                      label: const Text('Volver al listado'),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
