
import 'dart:async';

import 'package:injectable/injectable.dart';

import 'TaskModel.dart';

@injectable
@Singleton()
// Repository
class TaskService {
  List<TaskData> tasks = [];
  static final TaskService _tr = TaskService._privateConstructor();
  StreamController<List<TaskData>> changeController =
  StreamController<List<TaskData>>();

  Stream<List<TaskData>> get taskListStream => changeController.stream;

  TaskService._privateConstructor();

  factory TaskService() {
    return _tr;
  }

  Future<List<TaskData>> list() async {
    return tasks;
  }

  Future<void> addTask(TaskData item) async {
    tasks.add(item);
  }

  Future<void> update(TaskData updatedItem) async {
    int i = tasks.indexWhere((element) => element.id == updatedItem.id);
    tasks[i] = updatedItem;
  }

  Future<TaskData?> findOne(String id) async {
    return tasks.firstWhere((element) => element.id == id);
  }

  Future<void> delete(String id) async {
    tasks.removeWhere((element) => element.id == id);
  }

}
