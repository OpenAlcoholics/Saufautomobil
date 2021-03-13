import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sam/domain/bloc/welcome.dart';
import 'package:sam/infrastructure/dependency/dependency_container.dart';
import 'package:sam/ui/common.dart';
import 'package:sam/ui/init/welcome_content.dart';
import 'package:sam/ui/widget/injected_bloc_provider.dart';

class Initializer extends StatefulWidget {
  final Widget nextPage;

  const Initializer({required this.nextPage}) : super();

  @override
  _InitializerState createState() => _InitializerState();
}

class _InitializerState extends State<Initializer> {
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    await configureDependencies();
    setState(() {
      _isInitialized = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isInitialized) {
      return InjectedBlocProvider<WelcomeBloc>(
        child: Builder(
          builder: (context) => BlocBuilder<WelcomeBloc, WelcomeState>(
            bloc: Provider.of<WelcomeBloc>(context),
            builder: (context, state) => WelcomeContent(
              state: state,
            ),
          ),
        ),
      );
    } else {
      return const WelcomeContent(state: WelcomeState.loading());
    }
  }
}
