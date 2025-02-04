import 'package:json_annotation/json_annotation.dart';

part 'edit_task.g.dart';

/// A class representing an editable task.
@JsonSerializable()
class EditTask {
  /// The image associated with the task.
  final String? image;

  /// The title of the task.
  final String? title;

  /// The description of the task.
  final String? desc;

  /// The priority level of the task.
  final String? priority;

  /// The status of the task.
  final String? status;

  /// The user associated with the task.
  final String? user;

  /// Creates an instance of [EditTask].
  const EditTask({
    this.image,
    this.title,
    this.desc,
    this.priority,
    this.status,
    this.user,
  });

  /// Creates an instance of [EditTask] from a JSON object.
  factory EditTask.fromJson(Map<String, dynamic> json) =>
      _$EditTaskFromJson(json);

  /// Converts an instance of [EditTask] to a JSON object.
  Map<String, dynamic> toJson() => _$EditTaskToJson(this);
}