import 'dart:async';

import 'package:sam/data/stateful_stream.dart';
import 'package:sam/view/common.dart';

class StatefulStreamSubscription<T> extends StatefulWidget {
  final Widget child;
  final StatefulStream<T> stream;
  final void Function(T) onValue;
  final void Function(dynamic) onError;

  const StatefulStreamSubscription({
    Key key,
    @required this.child,
    @required this.stream,
    this.onValue,
    this.onError,
  }) : super(key: key);

  @override
  _StatefulStreamSubscriptionState<T> createState() =>
      _StatefulStreamSubscriptionState<T>();
}

class _StatefulStreamSubscriptionState<T>
    extends State<StatefulStreamSubscription<T>> {
  StreamSubscription<T> _sub;

  StreamSubscription<T> _subscribe() {
    return widget.stream.stream.listen(
      _onValue,
      onError: _onError,
    );
  }

  _onValue(T value) {
    if (widget.onValue != null) {
      widget.onValue(value);
    }
  }

  _onError(error) {
    if (widget.onError != null) {
      widget.onError(error);
    }
  }

  @override
  void initState() {
    super.initState();
    _sub = _subscribe();
  }

  @override
  void didUpdateWidget(StatefulStreamSubscription<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    _sub?.cancel();
    _sub = _subscribe();
  }

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
