import 'package:flutter/material.dart';
import 'package:org_app/taskList/TaskModel.dart';
import 'package:org_app/taskList/TaskListViewModel.dart';
import 'package:org_app/taskList/TaskView.dart';
import 'package:provider/provider.dart';

import 'PlannerAppView.dart';
import 'StateData.dart';
import 'TaskList.dart';

class TaskListScreen extends StatelessWidget {
  const TaskListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Planner App')),
      body: Stack(
        fit: StackFit.expand,
        children: [
          TaskViewWidget(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (//TODO add action or widget for adding task
            ) {

        },
      ),
    );
  }
}


}


}