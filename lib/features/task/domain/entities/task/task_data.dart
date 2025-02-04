import 'package:json_annotation/json_annotation.dart';

part 'task_data.g.dart';

/// A class representing the data of a task.
///
/// This class is annotated with `@JsonSerializable` to indicate that it can be
/// serialized to and from JSON.
@JsonSerializable()
class TaskData {
  /// The unique identifier of the task.
  @JsonKey(name: '_id')
  final String? id;

  /// The image associated with the task.
  final String? image;

  /// The title of the task.
  final String? title;

  /// The description of the task.
  final String? desc;

  /// The priority level of the task.
  final String? priority;

  /// The current status of the task.
  final String? status;

  /// The user associated with the task.
  final String? user;

  /// The creation timestamp of the task.
  final String? createdAt;

  /// The last updated timestamp of the task.
  final String? updatedAt;

  /// The version number of the task.
  @JsonKey(name: '__v')
  final int? V;

  /// Constructs a new `TaskData` instance.
  ///
  /// All fields are optional and can be null.
  const TaskData({
    this.id,
    this.image,
    this.title,
    this.desc,
    this.priority,
    this.status,
    this.user,
    this.createdAt,
    this.updatedAt,
    this.V,
  });

  /// Creates a new `TaskData` instance from a JSON object.
  ///
  /// The [json] parameter must be a map containing key-value pairs that
  /// correspond to the fields of `TaskData`.
  factory TaskData.fromJson(Map<String, dynamic> json) =>
      _$TaskDataFromJson(json);

  /// Converts this `TaskData` instance to a JSON object.
  ///
  /// Returns a map containing key-value pairs that correspond to the fields
  /// of `TaskData`.
  Map<String, dynamic> toJson() => _$TaskDataToJson(this);
}