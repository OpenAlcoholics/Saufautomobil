import 'package:sam/view/common.dart';
import 'package:sam/view/widget/player/player_controller.dart';

class PlayerPageFloatingActionButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<PlayerController>(context);
    return ValueListenableBuilder<bool>(
      valueListenable: controller.isEditing,
      builder: (context, isEditing, _) {
        final messages = context.messages.common;
        return FloatingActionButton(
          child: Icon(isEditing ? Icons.check : Icons.edit),
          onPressed: () => controller.toggleEditing(),
          tooltip: isEditing ? messages.submit : messages.edit,
        );
      },
    );
  }
}
