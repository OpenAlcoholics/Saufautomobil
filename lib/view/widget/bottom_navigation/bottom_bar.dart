import 'package:sam/view/common.dart';
import 'package:sam/view/page/game_page.dart';
import 'package:sam/view/page/player_page.dart';
import 'package:sam/view/resource/messages.i18n.dart';
import 'package:sam/view/widget/routing/unanimated_route.dart';

class SamBottomNavigationBar extends StatelessWidget {
  final SamPage activePage;

  const SamBottomNavigationBar({
    Key key,
    @required this.activePage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: SamPage.values
          .map((it) => _createItem(context, it))
          .toList(growable: false),
      currentIndex: activePage.index,
      onTap: (index) {
        if (index != activePage.index) {
          Navigator.of(context).pushReplacement(UnanimatedRoute(
            builder: (_) => SamPage.values[index].buildPage(),
          ));
        }
      },
    );
  }

  BottomNavigationBarItem _createItem(BuildContext context, SamPage page) {
    return BottomNavigationBarItem(
      title: Text(page.getTitle(context.messages.bottom)),
      icon: Icon(page.getIcon()),
    );
  }
}

enum SamPage { game, rules, players }

extension on SamPage {
  // ignore: missing_return
  String getTitle(BottomMessages messages) {
    switch (this) {
      case SamPage.game:
        return messages.game;
      case SamPage.rules:
        return messages.rules;
      case SamPage.players:
        return messages.players;
    }
  }

  // ignore: missing_return
  IconData getIcon() {
    switch (this) {
      case SamPage.game:
        return Icons.local_drink;
      case SamPage.rules:
        return Icons.book;
      case SamPage.players:
        return Icons.people;
    }
  }

  // ignore: missing_return
  Widget buildPage() {
    switch (this) {
      case SamPage.game:
        return GamePage();
      case SamPage.rules:
        return Text("Whoops");
      case SamPage.players:
        return PlayerPage();
    }
  }
}
