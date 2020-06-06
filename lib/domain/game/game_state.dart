import 'package:sam/data/stateful_stream.dart';
import 'package:sam/domain/game/rule.dart';
import 'package:sam/domain/model.dart';

class GameState {
  final UpdatableStatefulStream<List<Task>> tasks = UpdatableStatefulStream();
  final UpdatableStatefulStream<int> currentRound = UpdatableStatefulStream();

  final UpdatableStatefulStream<List<String>> players =
      UpdatableStatefulStream();
  final UpdatableStatefulStream<int> currentPlayer = UpdatableStatefulStream();

  UpdatableStatefulStream<List<Rule>> activeRules = UpdatableStatefulStream();
}
