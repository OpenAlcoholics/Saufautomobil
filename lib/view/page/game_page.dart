import 'package:sam/view/common.dart';
import 'package:sam/view/page/player_page.dart';
import 'package:sam/view/widget/game/game_controller.dart';
import 'package:sam/view/widget/game/game_title.dart';

class GamePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (_) => GameController(),
      dispose: (_, it) => it.dispose(),
      child: Scaffold(
        appBar: AppBar(
          title: GameTitle(),
          actions: [
            IconButton(
              icon: Icon(Icons.people),
              tooltip: context.messages.action.editPlayers,
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => PlayerPage()),
              ),
            )
          ],
        ),
        body: Text("GAME ON"),
      ),
    );
  }
}
