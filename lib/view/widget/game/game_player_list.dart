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
            final controller = ScrollController(
              initialScrollOffset: currentPlayer * 40.0,
            );
            return SizedBox(
              height: 32,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                controller: controller,
                separatorBuilder: (context, index) => const SizedBox(width: 8),
                itemCount: players.length,
                itemBuilder: (context, index) {
                  return PlayerChip(
                    player: players[index],
                    isActive: index == currentPlayer,
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}
