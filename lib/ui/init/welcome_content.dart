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
  final LoadingValue<GameConfiguration> configuration;

  const _NewGameButton(this.configuration) : super();

  void _startNewGame(BuildContext context, GameConfiguration configuration) {
    Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (_) => PlaceholderPage(),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return _LoadingButton<GameConfiguration>(
      text: context.messages.init.newGame,
      loading: configuration,
      onPressed: (value) => _startNewGame(context, value),
    );
  }
}

class _ResumeGameButton extends StatelessWidget {
  final LoadingValue<GameState?> gameState;

  const _ResumeGameButton(this.gameState) : super();

  void _resumeGame(BuildContext context, GameState state) {
    Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (_) => PlaceholderPage(),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return _LoadingButton<GameState>(
      text: context.messages.init.resume,
      loading: gameState,
      onPressed: (value) => _resumeGame(context, value),
    );
  }
}

class _LoadingButton<T> extends StatelessWidget {
  final LoadingValue<T?> loading;
  final String text;
  final Function(T value) onPressed;

  const _LoadingButton({
    required this.loading,
    required this.text,
    required this.onPressed,
  }) : super();

  Widget _createButtonContent(BuildContext context) {
    final text = Text(this.text);
    if (loading.isLoaded) {
      return text;
    } else {
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
    }
  }

  Function()? _onPressed() {
    if (loading.isLoaded) {
      final value = loading.value;
      if (value != null) {
        return () => onPressed(value);
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: _onPressed(),
      child: _createButtonContent(context),
    );
  }
}
