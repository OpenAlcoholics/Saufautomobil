import 'package:sam/domain/model/loading_value.dart';
import 'package:sam/infrastructure/dependency/dependency_container.dart';
import 'package:sam/ui/common.dart';
import 'package:sam/ui/widget/welcome_content.dart';

class Initializer extends StatefulWidget {
  final Widget nextPage;

  const Initializer({required this.nextPage}) : super();

  @override
  _InitializerState createState() => _InitializerState();
}

class _InitializerState extends State<Initializer> {
  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    await configureDependencies();
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => widget.nextPage,
        transitionDuration: Duration.zero,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // ignore: prefer_const_constructors
    return WelcomeContent(state: const LoadingValue.loading());
  }
}
