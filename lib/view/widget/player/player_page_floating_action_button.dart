import 'package:sam/view/common.dart';
import 'package:sam/view/widget/player/player_controller.dart';

class PlayerPageFloatingActionButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<PlayerController>(context);
    return ValueListenableBuilder(
      valueListenable: controller.players,
      child: Icon(Icons.check),
      builder: (context, value, child) {
        if (value == null || value.isEmpty) {
          return Container();
        } else {
          return FloatingActionButton(
            child: child,
            onPressed: _onPressed,
            tooltip: context.messages.common.submit,
          );
        }
      },
    );
  }

  void _onPressed() {
    print("User wants to move on from player selection");
  }
}
