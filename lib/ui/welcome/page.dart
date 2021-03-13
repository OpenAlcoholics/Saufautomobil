import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sam/domain/bloc/welcome.dart';
import 'package:sam/domain/model/loading_value.dart';
import 'package:sam/ui/common.dart';
import 'package:sam/ui/widget/injected_bloc_provider.dart';
import 'package:sam/ui/widget/welcome_content.dart';

class WelcomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InjectedBlocProvider<WelcomeBloc>(
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
      body: Stack(
        children: [
          _ErrorBanner(),
          _WelcomeContentBuilder(),
        ],
      ),
    );
  }
}

class _WelcomeContentBuilder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WelcomeBloc, WelcomeState>(
      builder: (context, state) => WelcomeContent(state: state),
    );
  }
}

class _ErrorBanner extends StatelessWidget {
  String _getMessage(ErrorInitMessages messages, CardSpecLoadingError error) {
    switch (error) {
      case CardSpecLoadingError.ioError:
        return messages.ioError;
      case CardSpecLoadingError.parsingError:
        return messages.parsingError;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WelcomeBloc, WelcomeState>(
      builder: (context, state) {
        if (state.newGameConfig.state == LoadingState.error) {
          final error = state.newGameConfig.error;
          return MaterialBanner(
            leading: const Icon(Icons.error),
            content: Text(_getMessage(context.messages.init.error, error)),
            actions: [
              TextButton(
                onPressed: () {
                  BlocProvider.of<WelcomeBloc>(context).add(RetryNewGame());
                },
                child: Text(context.messages.common.retry),
              ),
            ],
          );
        } else {
          return Container();
        }
      },
    );
  }
}
