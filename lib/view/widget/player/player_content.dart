import 'package:sam/view/common.dart';
import 'package:sam/view/widget/loading_indicator.dart';
import 'package:sam/view/widget/player/player_controller.dart';
import 'package:sam/view/widget/player/player_selection.dart';

class PlayerContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<PlayerController>(context);
    return SafeArea(
      child: ValueListenableBuilder(
        valueListenable: controller.players,
        builder: (context, value, _) {
          if (value == null) {
            return LoadingIndicator();
          } else {
            return PlayerSelection(players: value);
          }
        },
      ),
    );
  }
}
