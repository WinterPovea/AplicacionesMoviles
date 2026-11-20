import '../domain/task.dart';

abstract class TaskRepository {
  Future<List<Task>> getTasks();
  void save(Task task);
}
