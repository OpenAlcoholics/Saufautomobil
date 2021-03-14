import 'package:sam/domain/model/game_state.dart';
import 'package:sam/domain/model/loading_value.dart';
import 'package:sam/ui/common.dart';
import 'package:sam/ui/placeholder/page.dart';

class WelcomeContent extends StatelessWidget {
  final LoadingValue<GameState?, void> state;

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
  final LoadingValue<GameState?, void> state;

  const _InitContinuationPanel({required this.state}) : super();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const _NewGameButton(),
        _ResumeGameButton(state),
      ],
    );
  }
}

class _NewGameButton extends StatelessWidget {
  const _NewGameButton() : super();

  void _startNewGame(BuildContext context) {
    Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (_) => PlaceholderPage(),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => _startNewGame(context),
      child: Text(context.messages.init.newGame),
    );
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
