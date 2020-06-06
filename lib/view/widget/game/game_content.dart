import 'package:sam/view/common.dart';
import 'package:sam/view/widget/game/current_task.dart';

class GameContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: AlignmentDirectional.center,
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(child: CurrentTask()),
        ],
      ),
    );
  }
}
