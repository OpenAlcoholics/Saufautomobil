import 'package:sam/data/dependency_model.dart';
import 'package:sam/domain/game/persistence_load_service.dart';
import 'package:sam/domain/game/reset_service.dart';
import 'package:sam/view/common.dart';
import 'package:sam/view/page/init_page.dart';

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
        switch (item) {
          case _OverflowItem.reset:
            _reset(context);
            break;
        }
      },
    );
  }

  Future _reset(BuildContext context) async {
    await service<ResetService>().resetGame();
    final nav = Navigator.of(context);
    while (nav.canPop()) {
      nav.pop();
    }
    nav.pushReplacement(MaterialPageRoute(
      builder: (_) => InitPage(),
    ));
  }
}

enum _OverflowItem {
  reset,
}
