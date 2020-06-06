import 'package:sam/view/common.dart';
import 'package:sam/view/widget/init/init_content.dart';
import 'package:sam/view/widget/init/init_controller.dart';

class InitPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (_) => InitController(),
      dispose: (_, controller) => controller.dispose(),
      child: Scaffold(
        body: SafeArea(
          child: InitContent(),
        ),
      ),
    );
  }
}
