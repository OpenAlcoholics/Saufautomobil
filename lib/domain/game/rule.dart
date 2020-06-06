import 'package:sam/domain/game/task.dart';

class Rule implements Comparable<Rule> {
  final String player;
  final Task task;
  final int untilRound;

  Rule(
    this.task, {
    this.player,
    this.untilRound,
  });

  @override
  int compareTo(Rule other) {
    return untilRound.compareTo(other.untilRound);
  }
}
