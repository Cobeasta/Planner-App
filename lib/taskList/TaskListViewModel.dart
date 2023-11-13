// view model for task list
import 'dart:async';

import 'package:injectable/injectable.dart';

import '../StateData.dart';
import '../ViewModel.dart';
import 'TaskModel.dart';
import 'TaskRepository.dart';

@injectable
class TaskListViewModel extends ViewModel<TaskListStateData> {
  TaskListViewModel(this._taskRepository) : super(const TaskListStateData.initial());
  final TaskRepository _taskRepository;

  StreamSubscription<List<TaskTileData>>? _taskSub;

  void init() {
    _updateList();
// get the list of tasks from the task repository
    // Map currently stored tasks
    // convert
    _taskSub = _taskRepository
        .observeTaskList
        .map((tasklist) => tasklist.map(TaskTileData.fromData).toList())
        .listen(_onTaskChanged);

    // .map((todoList) => todoList.map(TaskData.fromTask).toList())
    // .listen(_onTaskChanged);
  }

  @override
  void dispose() {
    _taskSub?.cancel();
    super.dispose();
  }

  Future<void> changeTaskStatus(String id, bool isDone) async {
    await _taskRepository.updateTaskStatus(id, isDone);
  }

  void _updateState({
    List<TaskTileData>? tasks,
    bool? isLoading,
  }) {
    tasks ??= value.taskTiles;
    isLoading ??= value.showLoading;

    stateData = TaskListStateData(
        taskTiles: tasks,
        showEmptyState: tasks.isEmpty,
        showLoading: isLoading);
  }

  Future<void> _updateList() async {
    _updateState(isLoading: true);
    await _taskRepository.updateTaskList();
    _updateState(isLoading: false);
  }

  void _onTaskChanged(List<TaskTileData> tasks) {
    _updateState(tasks: tasks);
  }
}


/**
 * State for the tasklist widget
 */
class TaskListStateData extends StateData {
  const TaskListStateData({
    required this.taskTiles,
    required this.showEmptyState,
    required this.showLoading,
  });

  const TaskListStateData.initial()
      : taskTiles = const [],
        showLoading = false,
        showEmptyState = false;

  final List<TaskTileData> taskTiles;
  final bool showEmptyState;
  final bool showLoading;

  @override
  List<Object?> get props => [
    taskTiles,
    showEmptyState,
    showLoading,
  ];
}

/**
 * ViewModel data
 */
class TaskTileData {
  final String id;
  final String description;

  TaskTileData(this.id, this.description);

  static TaskTileData fromData(TaskData data) {
    return TaskTileData(data.id, data.description);
  }
}
