import 'package:sam/infrastructure/dependency/dependency_container.dart';
import 'package:sam/ui/common.dart';

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
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => widget.nextPage,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}
