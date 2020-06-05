import 'package:sam/view/common.dart';

class SamOverflowMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<_OverflowItem>(
      itemBuilder: (context) => [
        PopupMenuItem(
          value: _OverflowItem.reset,
          child: Text(context.messages.action.resetGame),
        ),
      ],
      onSelected: (item) {
        // TODO reset
        print("Selected $item");
      },
    );
  }
}

enum _OverflowItem {
  reset,
}
