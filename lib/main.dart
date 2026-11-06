import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

void main() {
  runApp(const TaskFlowApp());
}

// 1. MODELO DE DATOS
class Task {
  const Task({
    required this.id,
    required this.title,
    required this.description,
    required this.priority,
    required this.isCompleted,
  });

  final int id;
  final String title;
  final String description;
  final String priority;
  final bool isCompleted;
}

// 2. BACKLOG ESTÁTICO (Fuente temporal de datos)
const demoTasks = [
  Task(
    id: 1,
    title: 'Modelar estructura de datos',
    description: 'Definir campos id, title, description, priority y status',
    priority: 'Alta',
    isCompleted: true,
  ),
  Task(
    id: 2,
    title: 'Diseñar widget TaskCard',
    description: 'Presentar prioridad, título y acción visual con ListTile',
    priority: 'Alta',
    isCompleted: true,
  ),
  Task(
    id: 3,
    title: 'Configurar GoRouter',
    description: 'Implementar rutas declarativas para navegación entre pantallas',
    priority: 'Media',
    isCompleted: false,
  ),
  Task(
    id: 4,
    title: 'Pantalla de detalle',
    description: 'Mostrar información detallada recibiendo el ID de la tarea',
    priority: 'Media',
    isCompleted: false,
  ),
  Task(
    id: 5,
    title: 'Validación con flutter analyze',
    description: 'Garantizar buenas prácticas de código limpio y const',
    priority: 'Baja',
    isCompleted: false,
  ),
];

// 3. DECLARACIÓN DE RUTAS (GoRouter)
final appRouter = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const TaskListScreen(),
    ),
    GoRoute(
      path: '/task/:id',
      builder: (context, state) {
        final taskId = int.parse(state.pathParameters['id']!);
        return TaskDetailScreen(taskId: taskId);
      },
    ),
  ],
);

// 4. APLICACIÓN PRINCIPAL (MaterialApp.router)
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

// 5. PANTALLA PRINCIPAL (TaskListScreen)
class TaskListScreen extends StatelessWidget {
  const TaskListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Backlog de Tareas'),
        centerTitle: true,
      ),
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

// 6. TARJETA DE TAREA (TaskCard navegable)
class TaskCard extends StatelessWidget {
  const TaskCard({
    super.key,
    required this.task,
    this.onTap,
  });

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
        title: Text(task.title),
        subtitle: Text('${task.priority} · ${task.description}'),
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }
}

// 7. PANTALLA DE DETALLE (Con acción visual contextual)
class TaskDetailScreen extends StatelessWidget {
  const TaskDetailScreen({super.key, required this.taskId});

  final int taskId;

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
    final task = demoTasks.firstWhere((item) => item.id == taskId);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle de tarea'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Acción visual contextual: Tarjeta de estado dinámico
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: task.isCompleted
                    ? Colors.green.withAlpha(25)
                    : Colors.amber.withAlpha(25),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: task.isCompleted ? Colors.green : Colors.amber.shade800,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    task.isCompleted ? Icons.check_circle : Icons.pending,
                    color: task.isCompleted ? Colors.green : Colors.amber.shade800,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    task.isCompleted ? 'Tarea Finalizada' : 'Tarea en Progreso',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: task.isCompleted ? Colors.green.shade900 : Colors.amber.shade900,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              task.title,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            Text(
              task.description,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Chip(
                  avatar: const Icon(Icons.flag, size: 16),
                  label: Text('Prioridad: ${task.priority}'),
                  backgroundColor: _getPriorityColor(task.priority).withAlpha(25),
                ),
                const SizedBox(width: 12),
                Chip(
                  label: Text('ID: #${task.id}'),
                ),
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