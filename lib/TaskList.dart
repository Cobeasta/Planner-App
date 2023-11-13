import 'dart:async';

import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:org_app/Screen.dart';
import 'package:org_app/ViewModel.dart';
import 'package:provider/provider.dart';
import 'package:org_app/task_progress.dart';

import 'StateData.dart';

// state with list of tasks.
class TaskListData extends StateData {
  const TaskListData({
    required this.taskTiles,
    required this.showEmptyState,
    required this.showLoading,
  });

  const TaskListData.initial()
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

// view model for task list
@injectable
class TaskListViewModel extends ViewModel<TaskListData> {
  TaskListViewModel(this._taskRepository) : super(const TaskListData.initial());
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

    stateData = TaskListData(
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

/*// model
class TaskData {
  final String id;
  final String description;

  TaskData(this.id, this.description);

  static  fromTask(TaskData to) {
    return TaskData(to.id, to.description);
  }
}*/
// model
class TaskData {
  final String id;
  final String description;

  TaskData(this.id, this.description);

  TaskData.FromTile(TaskTileData data)
      : id = data.id,
        description = data.description;
}

class TaskTileData {
  final String id;
  final String description;

  TaskTileData(this.id, this.description);

  static TaskTileData fromData(TaskData data) {
    return TaskTileData(data.id, data.description);
  }

// StreamController<TaskData> taskChangeController = StreamController<
//     TaskData>();
// Stream<TaskData> get FromData(TaskData data) =>
}

class TaskChange {
  final String id;
  final bool isDone;

  TaskChange(this.id, this.isDone);
}


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

// Views
class TaskListScreen extends Screen {
  const TaskListScreen({Key? key}) : super(key: key);

  @override
  _TaskListState createState() => _TaskListState();
}

class _TaskListState
    extends ScreenState<TaskListScreen, TaskListViewModel, TaskListData> {
  @override
  void initState() {
    super.initState();
    viewModel.init();
  }

  @override
  Widget buildScreen(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Planner App')),
      body: Stack(
        fit: StackFit.expand,
        children: [
          _TaskList(changeListener: _taskChangeListener),
          const Center(child: _ProgressBar()),
          const _EmptyState(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {

        },
      ),
    );
  }

  void _taskChangeListener(TaskChange change) {
    viewModel.changeTaskStatus(change.id, change.isDone);
  }
}

class _ProgressBar extends StatelessWidget {
  const _ProgressBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Selector<TaskListData, bool>(
      selector: (_, data) => data.showLoading,
      builder: (context, showLoading, _) => Visibility(
        visible: showLoading,
        child: const CircularProgressIndicator(),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Selector<TaskListData, bool>(
      selector: (_, data) => data.showEmptyState,
      builder: (context, showEmptyState, _) => Visibility(
        visible: showEmptyState,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: Text(
            'Add something first',
            style: Theme.of(context).textTheme.headline4,
          ),
        ),
      ),
    );
  }
}

class _TaskList extends StatelessWidget {
  const _TaskList({
    Key? key,
    required this.changeListener,
  }) : super(key: key);
  final ValueChanged<TaskChange> changeListener;

  @override
  Widget build(BuildContext context) {
    return Selector<TaskListData, List<TaskTileData>>(
      selector: (_, data) => data.taskTiles,
      builder: (context, tasks, _) {
        return ListView.separated(
          itemBuilder: (context, index) {},
          separatorBuilder: (_, __) => const Divider(),
          itemCount: tasks.length,
        );
      },
    );
  }
}
