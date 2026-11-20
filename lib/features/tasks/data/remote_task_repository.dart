import '../domain/task.dart';
import 'task_api_service.dart';
import 'task_repository.dart';

class RemoteTaskRepository implements TaskRepository {
  RemoteTaskRepository(this._apiService);

  final TaskApiService _apiService;
  List<Task> _tasks = [];

  @override
  Future<List<Task>> getTasks() async {
    _tasks = await _apiService.getTasks();
    return List.unmodifiable(_tasks);
  }

  @override
  void save(Task task) {
    final index = _tasks.indexWhere((item) => item.id == task.id);
    if (index == -1) return;
    _tasks[index] = task;
  }
}
