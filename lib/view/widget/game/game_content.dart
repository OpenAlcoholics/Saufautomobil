import 'package:sam/view/common.dart';
import 'package:sam/view/widget/game/current_task.dart';
import 'package:sam/view/widget/game/game_controller.dart';

class GameContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<GameController>(context);
    return Container(
      alignment: AlignmentDirectional.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CurrentTask(),
          RaisedButton(
            onPressed: () => _next(controller),
            child: Text("Next"),
          )
        ],
      ),
    );
    return Text("Jup");
  }

  void _next(GameController controller) {
    controller.advance();
  }
}
