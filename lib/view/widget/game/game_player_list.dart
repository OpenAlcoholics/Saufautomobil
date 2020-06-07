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
            final indices = _buildIndices(currentPlayer, size: players.length);
            return SizedBox(
              height: 32,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                separatorBuilder: (context, index) {
                  return const SizedBox(width: 8);
                },
                itemCount: indices.length,
                itemBuilder: (context, index) {
                  final playerIndex = indices[index];
                  return PlayerChip(
                    player: players[playerIndex],
                    isActive: playerIndex == currentPlayer,
                  );
                },
              ),
            );
          },
        );
      },
    );
  }

  List<int> _buildIndices(int currentPlayer, {@required int size}) {
    if (size == 1) {
      return [0];
    } else if (size == 2) {
      return const [0, 1];
    } else {
      return [
        _calcPrevIndex(currentPlayer, size: size),
        currentPlayer,
        _calcNextIndex(currentPlayer, size: size),
      ];
    }
  }

  int _calcNextIndex(int currentPlayer, {@required int size}) {
    return (currentPlayer + 1) % size;
  }

  int _calcPrevIndex(int currentPlayer, {@required int size}) {
    if (currentPlayer == 0) {
      return size - 1;
    } else {
      return currentPlayer - 1;
    }
  }
}
