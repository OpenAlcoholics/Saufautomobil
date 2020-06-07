import 'package:sam/data/dependency_model.dart';
import 'package:sam/domain/game/game_state.dart';
import 'package:sam/view/common.dart';
import 'package:sam/view/widget/game/player_chip.dart';
import 'package:sam/view/widget/stream/stateful_stream_builder.dart';

class GamePlayerList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final gameState = service<GameState>();
    final playerStream = gameState.players;
    return StatefulStreamBuilder<List<String>>(
      stream: playerStream,
      builder: (context, _, players) {
        if (players.isEmpty) return Container();
        return StatefulStreamBuilder(
          stream: gameState.currentPlayer,
          builder: (context, _, currentPlayer) {
            final indices = _calcIndices(currentPlayer, players.length);
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: indices.map(
                (index) {
                  final isActive = index == currentPlayer;
                  return PlayerChip(
                    player: players[index],
                    isActive: isActive,
                  );
                },
              ).toList(growable: false),
            );
          },
        );
      },
    );
  }

  List<int> _calcIndices(int current, int size) {
    switch (size) {
      case 1:
        return const [0];
      case 2:
        return const [0, 1];
      default:
        return [
          _calcPrev(current, size),
          current,
          _calcNext(current, size),
        ];
    }
  }

  int _calcPrev(int current, int size) {
    if (current == 0) {
      return size - 1;
    } else {
      return current - 1;
    }
  }

  int _calcNext(int current, int size) {
    if (current + 1 == size) {
      return 0;
    } else {
      return current + 1;
    }
  }
}
