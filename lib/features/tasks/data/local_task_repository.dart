import '../domain/task.dart';
import 'task_repository.dart';

class LocalTaskRepository implements TaskRepository {
  final List<Task> _tasks = [
    const Task(
      id: 101,
      title: 'Configurar repositorio Git',
      description:
          'Inicializar rama principal y subir estructura base de Flutter',
      priority: 'Alta',
      isCompleted: true,
      userId: 1,
    ),
    const Task(
      id: 102,
      title: 'Definir modelo Task y JSON',
      description:
          'Implementar constructor const y factory fromJson en task.dart',
      priority: 'Alta',
      isCompleted: true,
      userId: 1,
    ),
    const Task(
      id: 103,
      title: 'Implementar listado con GoRouter',
      description: 'Configurar rutas / y /task/:id con parámetros dinámicos',
      priority: 'Media',
      isCompleted: false,
      userId: 1,
    ),
    const Task(
      id: 104,
      title: 'Redactar especificación en README',
      description: 'Documentar historias de usuario, criterios y contratos API',
      priority: 'Media',
      isCompleted: false,
      userId: 1,
    ),
    const Task(
      id: 105,
      title: 'Preparar formulario de creación',
      description:
          'Maquetar campos de título, descripción y selector de prioridad',
      priority: 'Baja',
      isCompleted: false,
      userId: 1,
    ),
  ];

  @override
  Future<List<Task>> getTasks() async => List.unmodifiable(_tasks);

  @override
  void save(Task task) {
    final index = _tasks.indexWhere((item) => item.id == task.id);
    if (index == -1) return;
    _tasks[index] = task;
  }
}
