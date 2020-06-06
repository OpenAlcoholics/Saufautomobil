import 'package:sam/data/dependency_model.dart';
import 'package:sam/domain/game/game_state.dart';
import 'package:sam/view/common.dart';
import 'package:sam/view/widget/stream/stateful_stream_builder.dart';

class CurrentTask extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final state = service<GameState>();
    final stream = state.currentRound;
    return StatefulStreamBuilder(
      stream: stream,
      builder: (context, _, currentRound) {
        final task = state.tasks.lastValue[currentRound];
        return Text(task.text);
      },
    );
  }
}
