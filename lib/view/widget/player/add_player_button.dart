import 'package:sam/view/common.dart';
import 'package:sam/view/resource/sam_colors.dart';
import 'package:sam/view/widget/input_dialog.dart';
import 'package:sam/view/widget/player/player_controller.dart';
import 'package:sam/view/widget/snackbar_dismiss_action.dart';

class AddPlayerButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<PlayerController>(context);
    return SizedBox(
      height: 60,
      child: Center(
        child: IconButton(
          iconSize: 48,
          icon: Icon(
            Icons.add_circle,
            color: SamColors.accent,
          ),
          onPressed: () => _add(context, controller),
        ),
      ),
    );
  }

  Future<void> _add(BuildContext context, PlayerController controller) async {
    final result = await showDialog(
      context: context,
      child: InputDialog(hint: context.messages.player.nameInputHint),
    );
    if (result != null) {
      try {
        await controller.addPlayer(result);
      } on ArgumentError {
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text(context.messages.player.duplicate),
          action: dismissSnackBarAction(context),
        ));
      }
    }
  }
}
