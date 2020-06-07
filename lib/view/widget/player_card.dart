import 'package:sam/data/dependency_model.dart';
import 'package:sam/domain/game/game_state.dart';
import 'package:sam/view/common.dart';
import 'package:sam/view/widget/stream/stateful_stream_builder.dart';

class PlayerCard extends StatelessWidget {
  final String player;
  final int index;
  final Widget trailing;

  const PlayerCard(
    this.player, {
    @required this.index,
    this.trailing,
  }) : super();

  @override
  Widget build(BuildContext context) {
    final activeState = service<GameState>().currentPlayer;
    return StatefulStreamBuilder<int>(
      stream: activeState,
      builder: (context, _, activeIndex) {
        final isActive = activeIndex == index;
        return Card(
          color: isActive ? Colors.lightGreenAccent : null,
          child: ListTile(
            title: Text(player),
            trailing: trailing,
          ),
        );
      },
    );
  }
}
