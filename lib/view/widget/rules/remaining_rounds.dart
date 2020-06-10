import 'package:sam/data/dependency_model.dart';
import 'package:sam/domain/game/game_state.dart';
import 'package:sam/view/common.dart';
import 'package:sam/view/widget/stream/stateful_stream_builder.dart';

class RemainingRounds extends StatelessWidget {
  final int untilRound;

  const RemainingRounds(this.untilRound) : super();

  @override
  Widget build(BuildContext context) {
    final stream = service<GameState>().currentRound;
    return StatefulStreamBuilder(
      stream: stream,
      builder: (context, child, int currentRound) {
        return Text(
          _calcRemaining(untilRound, currentRound),
          textScaleFactor: 2,
        );
      },
    );
  }

  String _calcRemaining(int untilRound, int currentRound) {
    if (untilRound == -1) {
      return " ";
    }
    final remaining = untilRound - currentRound;
    return remaining.toString();
  }
}
