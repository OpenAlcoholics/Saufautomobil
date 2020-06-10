import 'package:sam/domain/game/task.dart';

class Rule implements Comparable<Rule> {
  final String player;
  final Task task;
  final int untilRound;
  final int untilPlayerIndex;

  Rule(
    this.task, {
    this.player,
    this.untilRound,
    this.untilPlayerIndex,
  });

  @override
  int compareTo(Rule other) {
    return untilRound.compareTo(other.untilRound);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Rule &&
          runtimeType == other.runtimeType &&
          player == other.player &&
          task == other.task;

  @override
  int get hashCode => player.hashCode ^ task.hashCode;

  @override
  String toString() {
    return "$untilRound";
  }
}
