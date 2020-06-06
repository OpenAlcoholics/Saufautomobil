import 'package:sam/data/stateful_stream.dart';

class GameState {
  final UpdatableStatefulStream<int> currentRound = UpdatableStatefulStream();
}
