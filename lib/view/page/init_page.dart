import 'package:sam/data/dependency_model.dart';
import 'package:sam/domain/game/game_state.dart';
import 'package:sam/view/common.dart';
import 'package:sam/view/page/game_page.dart';
import 'package:sam/view/widget/init/init_content.dart';
import 'package:sam/view/widget/stream/stateful_stream_subscription.dart';

class InitPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final stream = service<GameState>().isInitialized;
    if (stream.lastValue) {
      // TODO this isn't safe
      Future.microtask(() => _moveOn(context));
    }
    return Scaffold(
      body: SafeArea(
        child: StatefulStreamSubscription(
          stream: stream,
          child: InitContent(),
          onValue: (isInitialized) {
            if (isInitialized) {
              _moveOn(context);
            }
          },
        ),
      ),
    );
  }

  _moveOn(BuildContext context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => GamePage(),
      ),
    );
  }
}

/*
    final stream = widget.stream;
    final lastValue = stream.lastValue;
    if (lastValue != null) {
      _onValue(lastValue);
    }

    final lastError = stream.lastError;
    if (lastError != null) {
      _onError(lastError);
    }
 */
