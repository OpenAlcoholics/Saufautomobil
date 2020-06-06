import 'package:sam/data/dependency_model.dart';
import 'package:sam/domain/game/game_service.dart';
import 'package:sam/domain/game/game_state.dart';
import 'package:sam/domain/tasks/tasks_state.dart';
import 'package:sam/view/common.dart';
import 'package:sam/view/page/game_page.dart';
import 'package:sam/view/resource/sam_colors.dart';
import 'package:sam/view/widget/future_creator.dart';
import 'package:sam/view/widget/init/init_controller.dart';
import 'package:sam/view/widget/stream/stateful_stream_builder.dart';

class InitControl extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final gameState = service<GameState>();
    final stream = gameState.isInitialized;
    final controller = Provider.of<InitController>(context);

    return FutureCreator(
      task: controller.updateTasks,
      builder: (context, taskUpdate) {
        return StatefulStreamBuilder(
          stream: stream,
          builder: (context, child, isInitialized) {
            if (isInitialized) {
              if (gameState.tasks.lastValue == null) {
                return StatefulStreamBuilder(
                  stream: controller.tasksLoaded,
                  builder: (context, _, isLoaded) {
                    if (isLoaded) {
                      return _ContinueButton(
                        text: context.messages.init.newGame,
                        onPressed: () => _startGame(context, controller),
                      );
                    } else {
                      return CircularProgressIndicator();
                    }
                  },
                );
              } else {
                return _ContinueButton(
                  text: context.messages.init.resume,
                  onPressed: () => _moveToGame(context),
                );
              }
            } else {
              return CircularProgressIndicator();
            }
          },
        );
      },
    );
  }

  Future<bool> _moveToGame(BuildContext context) async {
    await Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => GamePage(),
      ),
    );
    return true;
  }

  Future<bool> _startGame(
    BuildContext context,
    InitController controller,
  ) async {
    final tasks = service<TasksState>().tasks.lastValue;
    if (tasks == null) {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text(context.messages.common.errorNoTasks),
        action: SnackBarAction(
          label: context.messages.common.retry,
          onPressed: () {
            controller.updateTasks();
          },
        ),
      ));
      return false;
    } else {
      await service<GameService>().setTasks(tasks);
      await _moveToGame(context);
      return true;
    }
  }
}

class _ContinueButton extends StatefulWidget {
  final String text;
  final Future<bool> Function() onPressed;

  const _ContinueButton({
    Key key,
    @required this.text,
    @required this.onPressed,
  }) : super(key: key);

  @override
  __ContinueButtonState createState() => __ContinueButtonState();
}

class __ContinueButtonState extends State<_ContinueButton> {
  bool _isEnabled = true;

  Future<void> _onPressed() async {
    setState(() {
      _isEnabled = false;
    });
    if (!await widget.onPressed() && mounted) {
      setState(() {
        _isEnabled = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      color: SamColors.accent,
      textColor: Colors.white,
      child: Text(widget.text),
      onPressed: _isEnabled ? _onPressed : null,
    );
  }
}
