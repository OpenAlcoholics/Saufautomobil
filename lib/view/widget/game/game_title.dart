import 'package:sam/data/dependency_model.dart';
import 'package:sam/domain/game/game_state.dart';
import 'package:sam/view/common.dart';
import 'package:sam/view/widget/stream/stateful_stream_builder.dart';

class GameTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final gameState = service<GameState>();
    final taskCount = gameState.tasks.lastValue.length;
    final stream = gameState.currentRound;
    return StatefulStreamBuilder(
      stream: stream,
      builder: (context, _, currentRound) {
        return Text(context.messages.page.gameOngoing(
          currentRound,
          taskCount,
        ));
      },
    );
  }
}
