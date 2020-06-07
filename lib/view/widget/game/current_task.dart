import 'package:sam/data/dependency_model.dart';
import 'package:sam/domain/game/game_state.dart';
import 'package:sam/view/common.dart';
import 'package:sam/view/widget/stream/stateful_stream_builder.dart';

class CurrentTask extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final state = service<GameState>();
    final stream = state.currentTurn;
    return StatefulStreamBuilder(
      stream: stream,
      builder: (context, _, currentRound) {
        final tasks = state.tasks.lastValue;
        if (tasks == null) {
          return Container();
        }
        final task = tasks[currentRound];
        return Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
              child: Text(
                task.text,
                textAlign: TextAlign.center,
                style: TextStyle(
                  inherit: true,
                  fontSize: 32,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
