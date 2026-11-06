import 'package:flutter/material.dart';

void main() {
  runApp(const TaskFlowApp());
}

class TaskFlowApp extends StatelessWidget {
  const TaskFlowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TaskFlow',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      // Mostramos directamente la lista de tareas para el codelab actual
      home: const TaskListScreen(),
    );
  }
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

// 2. BACKLOG ESTÁTICO (5 tareas auténticas del proyecto TaskFlow)
const demoTasks = [
  Task(
    id: 1,
    title: 'Modelar estructura de datos',
    description: 'Definir campos id, title, description, priority y status',
    priority: 'Alta',
    isCompleted: true, // Evidencia de tarea completada
  ),
  Task(
    id: 2,
    title: 'Diseñar widget TaskCard',
    description: 'Presentar prioridad, título y acción visual con ListTile',
    priority: 'Alta',
    isCompleted: true, // Evidencia de tarea completada
  ),
  Task(
    id: 3,
    title: 'Implementar ListView.builder',
    description: 'Renderizar lista dinámica y optimizada con padding',
    priority: 'Media',
    isCompleted: false,
  ),
  Task(
    id: 4,
    title: 'Añadir modal de detalle',
    description: 'Mostrar descripción completa al presionar cada tarjeta',
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

// 3. PANTALLA PRINCIPAL DE TAREAS
class TaskListScreen extends StatelessWidget {
  const TaskListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Backlog de Tareas'), centerTitle: true),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: demoTasks.length,
        itemBuilder: (context, index) {
          final task = demoTasks[index];
          return TaskCard(task: task);
        },
      ),
    );
  }
}

// 4. TARJETA DE TAREA (Con acción visual de detalle)
class TaskCard extends StatelessWidget {
  const TaskCard({super.key, required this.task});

  final Task task;

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

  void _showTaskDetail(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Chip(
                    label: Text(task.priority),
                    backgroundColor: _getPriorityColor(task.priority)
                        .withAlpha(30),
                  ),
                  Text(
                    task.isCompleted ? 'Completada' : 'Pendiente',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: task.isCompleted ? Colors.green : Colors.grey,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(task.title, style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 8),
              Text(task.description),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(
          task.isCompleted ? Icons.check_circle : Icons.radio_button_unchecked,
          color: task.isCompleted ? Colors.green : Colors.grey,
          size: 28,
        ),
        title: Text(
          task.title,
          style: TextStyle(
            decoration: task.isCompleted ? TextDecoration.lineThrough : null,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text('${task.priority} · ${task.description}'),
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => _showTaskDetail(context), // Acción visual de detalle
      ),
    );
  }
}
