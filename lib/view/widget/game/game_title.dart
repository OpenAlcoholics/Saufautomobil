import 'package:sam/view/common.dart';
import 'package:sam/view/widget/game/game_controller.dart';

class GameTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Provider.of<GameController>(context).taskCount,
      builder: (context, value, _) {
        if (value > 0) {
          return Text(context.messages.page.gameOngoing(value));
        } else {
          return Text(context.messages.page.game);
        }
      },
    );
  }
}
