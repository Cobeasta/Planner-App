import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../PlannerAppView.dart';
import 'TaskModel.dart';
import 'TaskListViewModel.dart';

class TaskViewWidget extends PlannerAppView {
  const TaskViewWidget({Key? key}) : super(key: key);

  @override
  TaskListState createState() => TaskListState();
}

class TaskListState extends PlannerAppViewState<TaskViewWidget,
    TaskListViewModel, TaskListStateData> {
  @override
  void initState() {
    super.initState();
    viewModel.init();
  }

  @override
  Widget buildWidget(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      textDirection: TextDirection.ltr,
      fit: StackFit.expand,
      children: [
        TaskListWidget(changeListener: _taskChangeListener),
        const Center(child: TaskListProgressBarView()),
        const TaskListEmpty(),
      ],
    );
    //   StackFit.expand,
    // children: [
    // TaskListWidget(changeListener: _taskChangeListener),
    // const Center(child: TaskListProgressBarView()),
    // const TaskListEmpty(),
    // ]
  }

  void _taskChangeListener(TaskChange change) {
    viewModel.changeTaskStatus(change.id, change.isDone);
  }
}

class TaskListWidget extends StatelessWidget {
  const TaskListWidget({
    Key? key,
    required this.changeListener,
  }) : super(key: key);
  final ValueChanged<TaskChange> changeListener;

  @override
  Widget build(BuildContext context) {
    return Selector<TaskListStateData, List<TaskTileData>>(
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

class TaskListProgressBarView extends StatelessWidget {
  const TaskListProgressBarView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Selector<TaskListStateData, bool>(
      selector: (_, data) => data.showLoading,
      builder: (context, showLoading, _) => Visibility(
        visible: showLoading,
        child: const CircularProgressIndicator(),
      ),
    );
  }
}

class TaskListEmpty extends StatelessWidget {
  const TaskListEmpty({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Selector<TaskListStateData, bool>(
      selector: (_, data) => data.showEmptyState,
      builder: (context, showEmptyState, _) => Visibility(
        visible: showEmptyState,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: Text(
            'Add something first',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ),
      ),
    );
  }
}
