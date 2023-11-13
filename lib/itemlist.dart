import 'package:flutter/material.dart';

/**
 * @deprecated
 * Main widget for a list of tasks
 */
class TaskList extends StatefulWidget {
  const TaskList({super.key});

  @override
  State<StatefulWidget> createState() {
    return TaskListState();
  }
}

class TaskListState extends State<TaskList> with TickerProviderStateMixin {
  final List<CategoryItem> taskListCategories = [
    CategoryItem("heading 1", []),
    CategoryItem("heading 2", []),
    CategoryItem("heading 3", []),
    CategoryItem("heading 4", []),
    CategoryItem("heading 5", [])
  ];
  final GlobalKey _draggableKey = GlobalKey();

  void itemDroppedOnCategory(
      {required TaskItem taskItem, required CategoryItem categoryItem}) {
    setState(() {
      categoryItem.addTask(taskItem);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: buildContent(),
    );
  }

  Widget buildContent() {
    return ListView.builder(
        itemCount: taskListCategories.length,
        itemBuilder: (context, index) {
          final item = taskListCategories[index];
          return DragTarget(builder: (BuildContext context,
              List<dynamic> accepted, List<dynamic> rejected) {
            return ListTile(
              title: item.buildTitle(context),
              subtitle: item.buildSubtitle(context),
            );
          });
        });
  }
}

/**
 * A category in the app. These items are not draggable, they represent containers
 * of tasks. Basically a bucket of tasks
 */
class CategoryItem implements TaskListItem {
  final String heading;
  List<TaskItem> tasks;

  // TODO list of tasks under this heading
  CategoryItem(this.heading, this.tasks);

  @override
  Widget buildTitle(BuildContext context) {
    return Text(
      heading,
      style: Theme.of(context).textTheme.headlineSmall,
    );
  }

  @override
  Widget buildSubtitle(BuildContext context) {
    return ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final item = tasks[index];
        Widget itemWidget = ListTile(
          title: item.buildTitle(context),
          subtitle: item.buildSubtitle(context),
        );
        return LongPressDraggable<TaskItem>(
            data: item, feedback: itemWidget, child: itemWidget);

        ListTile(
            title: item.buildTitle(context),
            subtitle: item.buildSubtitle(context));
      },
    );
  }

  void addTask(TaskItem task) {
    tasks.add(task);
  }
}

class TaskItem implements TaskListItem {
  final String title;
  final String description;

  TaskItem(this.title, this.description);

  @override
  Widget buildTitle(BuildContext context) {
    return Text(title);
  }

  @override
  Widget buildSubtitle(BuildContext context) {
    return Text(
      description,
    );
  }
}

/// OLD
///
///

class ItemList extends StatelessWidget {
  final List<TaskListItem> items;

  const ItemList({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    const title = "Organization app";
    return MaterialApp(
      title: title,
      home: Scaffold(
        appBar: AppBar(
          title: const Text(title),
        ),
        body: ListView.builder(
          itemCount: 5,
          itemBuilder: (context, index) {
            final item = items[index];

            return ListTile(
                title: item.buildTitle(context),
                subtitle: item.buildSubtitle(context));
          },
        ),
      ),
    );
  }
}

// items and their widgets
abstract class TaskListItem {
  Widget buildTitle(BuildContext context);

  Widget buildSubtitle(BuildContext context);
}

class HeadingItem implements TaskListItem {
  final String heading;

  HeadingItem(this.heading);

  @override
  Widget buildTitle(BuildContext context) {
    return Text(
      heading,
      style: Theme.of(context).textTheme.headlineSmall,
    );
  }

  @override
  Widget buildSubtitle(BuildContext context) {
    return const SizedBox.shrink();
  }
}
