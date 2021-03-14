import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sam/domain/bloc/resumable_load.dart';
import 'package:sam/domain/model/game_state.dart';
import 'package:sam/domain/model/loading_value.dart';
import 'package:sam/ui/common.dart';
import 'package:sam/ui/welcome/welcome_content.dart';
import 'package:sam/ui/widget/injected_bloc_provider.dart';

class WelcomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return injectedBlocProvider<ResumableLoad>(
      child: _Content(),
    );
  }
}

class _Content extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.messages.page.init),
      ),
      body: _WelcomeContentBuilder(),
    );
  }
}

class _WelcomeContentBuilder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ResumableLoad, LoadingValue<GameState?, void>>(
      builder: (context, state) => WelcomeContent(state: state),
    );
  }
}
