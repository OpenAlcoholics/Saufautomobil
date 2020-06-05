import 'package:sam/view/common.dart';
import 'package:sam/view/widget/player/player_content.dart';
import 'package:sam/view/widget/player/player_controller.dart';
import 'package:sam/view/widget/player/player_page_floating_action_button.dart';

class PlayerPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider<PlayerController>(
      create: (_) => PlayerController(),
      dispose: (_, it) => it.dispose(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(context.messages.page.player),
        ),
        body: PlayerContent(),
        floatingActionButton: PlayerPageFloatingActionButton(),
      ),
    );
  }
}
