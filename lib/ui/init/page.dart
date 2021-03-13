import 'package:sam/ui/common.dart';
import 'package:sam/ui/init/initializer.dart';
import 'package:sam/ui/placeholder/page.dart';

class InitPage extends StatelessWidget {
  const InitPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Initializer(
        nextPage: PlaceholderPage(),
      ),
    );
  }
}
