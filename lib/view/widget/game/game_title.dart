import 'package:sam/data/dependency_model.dart';
import 'package:sam/domain/game/game_state.dart';
import 'package:sam/view/common.dart';
import 'package:sam/view/widget/stream/stateful_stream_builder.dart';

class GameTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final gameState = service<GameState>();
    final turnStream = gameState.currentTurn;
    final roundStream = gameState.currentRound;
    return StatefulStreamBuilder(
      stream: turnStream,
      builder: (context, _, currentTurn) {
        return StatefulStreamBuilder(
            stream: roundStream,
            builder: (context, _, currentRound) {
              return Text(context.messages.page.gameOngoing(
                // Do a +1 to hide the 0-based index
                taskCount: currentTurn + 1,
                roundCount: currentRound + 1,
              ));
            });
      },
    );
  }
}
