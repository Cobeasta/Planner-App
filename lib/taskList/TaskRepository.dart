import 'package:injectable/injectable.dart';

import 'TaskModel.dart';
import 'TaskService.dart';

abstract class ITaskRepository {
  Future<List<TaskData>> getAll();

  Future<TaskData?> getOne(String id);

  Future<void> add(TaskData task);

  Future<void> update(TaskData task);

  Future<void> delete(String id);
}

@injectable
class TaskRepository implements ITaskRepository {
  final TaskService _ts;

  TaskRepository(this._ts);

  Stream<List<TaskData>> get observeTaskList => _ts.taskListStream;

  @override
  Future<void> add(TaskData task) async {
    await _ts.addTask(task);
  }

  @override
  Future<void> delete(String id) async {
    await _ts.delete(id);
  }

  @override
  Future<List<TaskData>> getAll() async {
    return await _ts.list();
  }

  @override
  Future<TaskData?> getOne(String id) async {
    var item = await _ts.findOne(id);
    return item;
  }

  @override
  Future<void> update(TaskData task) async {
    await _ts.update(task);
  }

  // Get lists of tasks

  updateTaskList() {}

  updateTaskStatus(String id, bool isDone) {}
}