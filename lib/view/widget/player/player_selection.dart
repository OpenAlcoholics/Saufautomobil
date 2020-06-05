import 'package:sam/view/common.dart';
import 'package:sam/view/widget/player/add_player_button.dart';
import 'package:sam/view/widget/player/player_controller.dart';
import 'package:sam/view/widget/player_card.dart';

class PlayerSelection extends StatelessWidget {
  final List<String> players;

  const PlayerSelection({
    Key key,
    this.players,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<PlayerController>(context);
    return ListView.builder(
      itemCount: players.length + 1,
      itemBuilder: (context, index) {
        if (index == players.length) {
          return AddPlayerButton();
        }
        final player = players[index];
        return PlayerCard(
          player,
          trailing: IconButton(
            icon: Icon(Icons.remove_circle),
            onPressed: () => controller.removePlayer(player),
          ),
        );
      },
    );
  }
}
