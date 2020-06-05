import 'package:sam/view/common.dart';
import 'package:sam/view/widget/bottom_navigation/bottom_bar.dart';
import 'package:sam/view/widget/overflow/menu.dart';
import 'package:sam/view/widget/rules/rules_content.dart';
import 'package:sam/view/widget/rules/rules_controller.dart';

class RulesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (_) => RulesController(),
      dispose: (_, it) => it.dispose(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(context.messages.page.rules),
          actions: [SamOverflowMenu()],
        ),
        body: RulesContent(),
        bottomNavigationBar: SamBottomNavigationBar(
          activePage: SamPage.rules,
        ),
      ),
    );
  }
}
