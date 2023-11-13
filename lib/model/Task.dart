/**
 * Data model for a task
 */
class TaskData {
  final String id;
  final String description;

  TaskData(this.id, this.description);

  TaskData.FromTile(TaskTileData data)
      : id = data.id,
        description = data.description;
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

// StreamController<TaskData> taskChangeController = StreamController<
//     TaskData>();
// Stream<TaskData> get FromData(TaskData data) =>
}

class TaskChange {
  final String id;
  final bool isDone;

  TaskChange(this.id, this.isDone);
}