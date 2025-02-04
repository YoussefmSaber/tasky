import 'package:json_annotation/json_annotation.dart';

part 'add_task.g.dart';

/// A class representing a task to be added.
@JsonSerializable()
class AddTask {
  /// The image associated with the task.
  final String? image;

  /// The title of the task.
  final String? title;

  /// The description of the task.
  final String? desc;

  /// The priority of the task.
  final String? priority;

  /// The due date of the task.
  final String? dueDate;

  /// Creates an instance of [AddTask].
  const AddTask({
    this.image,
    this.title,
    this.desc,
    this.priority,
    this.dueDate,
  });

  /// Creates an instance of [AddTask] from a JSON object.
  factory AddTask.fromJson(Map<String, dynamic> json) =>
      _$AddTaskFromJson(json);

  /// Converts an instance of [AddTask] to a JSON object.
  Map<String, dynamic> toJson() => _$AddTaskToJson(this);
}