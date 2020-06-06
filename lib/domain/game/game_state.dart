import 'package:sam/data/stateful_stream.dart';
import 'package:sam/domain/game/rule.dart';
import 'package:sam/domain/game/task.dart';

class GameState {
  final UpdatableStatefulStream<bool> isInitialized =
      UpdatableStatefulStream(false);

  final UpdatableStatefulStream<List<Task>> tasks = UpdatableStatefulStream();
  final UpdatableStatefulStream<int> currentRound = UpdatableStatefulStream();

  final UpdatableStatefulStream<List<String>> players =
      UpdatableStatefulStream();
  final UpdatableStatefulStream<int> currentPlayer = UpdatableStatefulStream();

  final UpdatableStatefulStream<List<Rule>> activeRules =
      UpdatableStatefulStream();
}
