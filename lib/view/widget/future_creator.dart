import 'package:sam/view/common.dart';

class FutureCreator<T> extends StatefulWidget {
  final Future<T> Function() task;
  final Widget Function(BuildContext, Future<T>) builder;

  FutureCreator({
    @required this.task,
    @required this.builder,
  });

  @override
  _FutureCreatorState<T> createState() => _FutureCreatorState<T>();
}

class _FutureCreatorState<T> extends State<FutureCreator<T>> {
  Future<T> _future;

  @override
  void initState() {
    super.initState();
    _future = widget.task();
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, _future);
  }
}
