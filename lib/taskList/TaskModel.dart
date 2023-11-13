/**
 * Data model for a task
 */
class TaskData {
  final String id;
  final String description;

  TaskData(this.id, this.description);
}


class TaskChange {
  final String id;
  final bool isDone;
  TaskChange(this.id, this.isDone);
}