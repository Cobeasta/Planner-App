import 'package:flutter/material.dart';
import 'package:org_app/StateData.dart';
import 'package:org_app/ViewModel.dart';
import 'package:org_app/ViewModelFactory.dart';
import 'package:provider/provider.dart';

/**
 * Screen
 */
abstract class Screen extends StatefulWidget {
  const Screen({super.key});

  @override
  ScreenState createState();
}

abstract class ScreenState<screen extends Screen, VM extends ViewModel<stateData>,
    stateData extends StateData> extends State<screen> {
  ScreenState();

  late VM viewModel;

  Widget buildScreen(BuildContext context);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      ValueListenableProvider<stateData>.value(value: viewModel)
    ],
    builder: (context, _) => buildScreen(context),
    );
  }

  @override
  @mustCallSuper
  void initState() {
    super.initState();
    viewModel = context.read<ViewModelFactory>().create<VM>();
  }

  @override
  @mustCallSuper
  void dispose() {
    viewModel.dispose();
    super.dispose();
  }

}


//
// /**
//  * Main widget for a list of tasks
//  */
// class TaskList.dart extends StatefulWidget {
//   const TaskList.dart({super.key});
//
//   @override
//   State<StatefulWidget> createState() {
//     return TaskListState();
//   }
// }
//
// class TaskListState extends State<TaskList.dart> with TickerProviderStateMixin {
//   final List<CategoryItem> taskListCategories = [
//     CategoryItem("heading 1", []),
//     CategoryItem("heading 2", []),
//     CategoryItem("heading 3", []),
//     CategoryItem("heading 4", []),
//     CategoryItem("heading 5", [])
//   ];
//
//   // final List<TaskItem> taskListTasks = [
//   //   TaskItem(title, description)
//   // ];
//   final GlobalKey _draggableKey = GlobalKey();
//
//   void itemDroppedOnCategory(
//       {required TaskItem taskItem, required CategoryItem categoryItem}) {
//     setState(() {
//       categoryItem.addTask(taskItem);
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Theme.of(context).colorScheme.inversePrimary,
//       ),
//       body: buildContent(),
//     );
//   }
//
//   Widget buildContent() {
//     return ListView.builder(
//         itemCount: taskListCategories.length,
//         itemBuilder: (context, index) {
//           final item = taskListCategories[index];
//           return DragTarget(builder: (BuildContext context,
//               List<dynamic> accepted, List<dynamic> rejected) {
//             return ListTile(
//               title: item.buildTitle(context),
//               subtitle: item.buildSubtitle(context),
//             );
//           });
//         });
//   }
// }
//
// /**
//  * Abstract class representation of an item in the list
//  */
// abstract class TaskListItem {
//   Widget buildTitle(BuildContext context);
//
//   Widget buildSubtitle(BuildContext context);
// }
//
// /**
//  * A category in the app. These items are not draggable, they represent containers
//  * of tasks. Basically a bucket of tasks
//  */
// class CategoryItem implements TaskListItem {
//   final String heading;
//   List<TaskItem> tasks;
//
//   // TODO list of tasks under this heading
//   CategoryItem(this.heading, this.tasks);
//
//   @override
//   Widget buildTitle(BuildContext context) {
//     return Text(
//       heading,
//       style: Theme.of(context).textTheme.headlineSmall,
//     );
//   }
//
//   @override
//   Widget buildSubtitle(BuildContext context) {
//     return Text(
//       "Subitems",
//       style: Theme.of(context).textTheme.bodyMedium,
//     );
// return ListView.builder(
//   itemCount: tasks.length,
// itemBuilder: (context, index) {
//   final item = tasks[index];
//   Widget itemWidget = ListTile(
//     title: item.buildTitle(context),
//     subtitle: item.buildSubtitle(context),
//   );
//   return LongPressDraggable<TaskItem>(
//       data: item, feedback: itemWidget, child: itemWidget);
// }
//
// void addTask(TaskItem task) {
//   tasks.add(task);
// }
// }

// class TaskItem implements TaskListItem {
//   final String title;
//   final String description;
//
//   TaskItem(this.title, this.description);
//
//   @override
//   Widget buildTitle(BuildContext context) {
//     return Text(title);
//   }
//
//   @override
//   Widget buildSubtitle(BuildContext context) {
//     return Text(
//       description,
//     );
//   }
// }
