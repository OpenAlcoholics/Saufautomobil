import 'package:sam/view/common.dart';
import 'package:sam/view/widget/game/game_controller.dart';

class GameAdvanceButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<GameController>(context);
    return FloatingActionButton(
      child: Icon(Icons.arrow_forward),
      tooltip: context.messages.action.advance,
      onPressed: () => controller.advance(),
    );
  }
}
