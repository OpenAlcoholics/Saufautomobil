import 'package:sam/view/common.dart';
import 'package:sam/view/widget/bottom_navigation/bottom_bar.dart';
import 'package:sam/view/widget/game/game_content.dart';
import 'package:sam/view/widget/game/game_controller.dart';
import 'package:sam/view/widget/game/game_title.dart';
import 'package:sam/view/widget/overflow/menu.dart';

class GamePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (_) => GameController(),
      dispose: (_, it) => it.dispose(),
      child: Scaffold(
        appBar: AppBar(
          title: GameTitle(),
          actions: [SamOverflowMenu()],
        ),
        body: GameContent(),
        bottomNavigationBar: SamBottomNavigationBar(
          activePage: SamPage.game,
        ),
      ),
    );
  }
}
