import 'package:sam/domain/model.dart';

class Rule {
  final String player;
  final Task task;
  final int untilRound;

  Rule(
    this.task, {
    this.player,
    this.untilRound,
  });
}
