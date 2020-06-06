import 'package:json_annotation/json_annotation.dart';

part 'model.g.dart';

@JsonSerializable()
class TaskSpec {
  /// The task text.
  final String text;

  /// How often this task should be used per game
  final int count;

  /// How often this can be used (e.g. three immunities in future rounds)
  final int uses;

  /// How long this task is active
  final int rounds;

  /// Whether this task works remotely
  final bool remote;

  /// Whether only one instance of this task may be active
  final bool unique;

  TaskSpec({
    this.text,
    this.count,
    this.uses,
    this.rounds,
    this.remote,
    this.unique,
  });

  factory TaskSpec.fromJson(Map<String, dynamic> json) => _$TaskSpecFromJson(json);

  @override
  String toString() {
    return text;
  }
}
