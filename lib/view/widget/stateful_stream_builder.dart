import 'dart:async';

import 'package:sam/data/stateful_stream.dart';
import 'package:sam/view/common.dart';

class StatefulStreamBuilder<T> extends StatefulWidget {
  final StatefulStream<T> stream;
  final Widget child;
  final Widget Function(BuildContext, Widget child, T value) builder;

  const StatefulStreamBuilder({
    Key key,
    @required this.stream,
    @required this.builder,
    this.child,
  }) : super(key: key);

  @override
  _StatefulStreamBuilderState<T> createState() =>
      _StatefulStreamBuilderState<T>();
}

class _StatefulStreamBuilderState<T> extends State<StatefulStreamBuilder<T>> {
  StreamSubscription<T> _sub;

  StreamSubscription<T> _subscribe() {
    return widget.stream.stream.listen((event) {
      setState(() {});
    });
  }

  @override
  void initState() {
    super.initState();
    _sub = _subscribe();
  }

  @override
  void didUpdateWidget(StatefulStreamBuilder<T> oldWidget) {
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
    return widget.builder(context, widget.child, widget.stream.lastValue);
  }
}
