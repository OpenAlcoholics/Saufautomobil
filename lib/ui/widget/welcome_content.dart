import 'package:sam/domain/bloc/welcome.dart';
import 'package:sam/domain/model/game_configuration.dart';
import 'package:sam/domain/model/game_state.dart';
import 'package:sam/domain/model/loading_value.dart';
import 'package:sam/ui/common.dart';
import 'package:sam/ui/placeholder/page.dart';

class WelcomeContent extends StatelessWidget {
  final WelcomeState state;

  const WelcomeContent({required this.state}) : super();

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              const Spacer(),
              Expanded(
                flex: 2,
                child: Image.asset('assets/logo_transparent.png'),
              ),
              const Spacer(),
            ],
          ),
          const SizedBox(height: 40),
          _InitContinuationPanel(state: state),
        ],
      ),
    );
  }
}

class _InitContinuationPanel extends StatelessWidget {
  final WelcomeState state;

  const _InitContinuationPanel({required this.state}) : super();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _NewGameButton(state.newGameConfig),
        _ResumeGameButton(state.resumableState),
      ],
    );
  }
}

class _NewGameButton extends StatelessWidget {
  final LoadingValue<GameConfiguration, CardSpecLoadingError> configuration;

  const _NewGameButton(this.configuration) : super();

  void _startNewGame(BuildContext context, GameConfiguration value) {
    Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (_) => PlaceholderPage(),
    ));
  }

  @override
  Widget build(BuildContext context) {
    switch (configuration.state) {
      case LoadingState.loading:
        return _LoadingButton(
          text: context.messages.init.newGame,
          isLoading: true,
        );
      case LoadingState.error:
        return _LoadingButton(
          text: context.messages.init.newGame,
          isLoading: false,
        );
      case LoadingState.success:
        final value = configuration.value;
        return _LoadingButton(
          text: context.messages.init.newGame,
          isLoading: false,
          onPressed: () => _startNewGame(context, value),
        );
    }
  }
}

class _ResumeGameButton extends StatelessWidget {
  final LoadingValue<GameState?, void> gameState;

  const _ResumeGameButton(this.gameState) : super();

  void _resumeGame(BuildContext context, GameState state) {
    Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (_) => PlaceholderPage(),
    ));
  }

  @override
  Widget build(BuildContext context) {
    switch (gameState.state) {
      case LoadingState.loading:
        return _LoadingButton(
          text: context.messages.init.resume,
          isLoading: true,
        );
      case LoadingState.error:
        throw StateError('Did not expect to get errors from gameState');
      case LoadingState.success:
        final value = gameState.value;
        return _LoadingButton(
          text: context.messages.init.resume,
          isLoading: false,
          onPressed: value == null ? null : () => _resumeGame(context, value),
        );
    }
  }
}

class _LoadingButton extends StatelessWidget {
  final String text;
  final bool isLoading;
  final Function()? onPressed;

  const _LoadingButton({
    required this.text,
    required this.isLoading,
    this.onPressed,
  }) : super();

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: _createButtonContent(context),
    );
  }

  Widget _createButtonContent(BuildContext context) {
    final text = Text(this.text);
    if (isLoading) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          text,
          const SizedBox(width: 4),
          const SizedBox(
            height: 12,
            width: 12,
            child: CircularProgressIndicator(strokeWidth: 2.0),
          )
        ],
      );
    } else {
      return text;
    }
  }
}
