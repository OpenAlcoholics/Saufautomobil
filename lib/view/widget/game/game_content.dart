import 'package:sam/view/common.dart';
import 'package:sam/view/widget/game/current_task.dart';
import 'package:sam/view/widget/game/game_player_list.dart';

class GameContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(child: CurrentTask()),
        Divider(height: 2),
        GamePlayerList(),
      ],
    );
  }
}
