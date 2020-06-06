import 'dart:async';

import 'package:sam/data/stateful_stream.dart';
import 'package:sam/view/common.dart';
import 'package:sam/view/widget/loading_indicator.dart';
import 'package:sam/view/widget/retry_button.dart';

class StatefulStreamBuilder<T> extends StatefulWidget {
  final StatefulStream<T> stream;
  final Widget child;
  final Function() refresh;
  final Widget Function(BuildContext, Widget child) loadingBuilder;
  final Widget Function(BuildContext, Widget child, dynamic error) errorBuilder;
  final Widget Function(BuildContext, Widget child, T value) builder;

  const StatefulStreamBuilder({
    Key key,
    @required this.stream,
    @required this.builder,
    this.child,
    this.refresh,
    this.errorBuilder,
    this.loadingBuilder = _buildLoading,
  }) : super(key: key);

  @override
  _StatefulStreamBuilderState<T> createState() =>
      _StatefulStreamBuilderState<T>();
}

class _StatefulStreamBuilderState<T> extends State<StatefulStreamBuilder<T>> {
  StreamSubscription<T> _sub;

  StreamSubscription<T> _subscribe() {
    return widget.stream.stream.listen(
      (event) {
        setState(() {});
      },
      onError: _selectOnError(),
    );
  }

  Function(dynamic) _selectOnError() {
    if (widget.refresh == null && widget.errorBuilder == null) {
      return null;
    } else {
      return (error) {
        if (widget.stream.lastValue != null) {
          if (widget.refresh == null) {
            Scaffold.of(context).showSnackBar(SnackBar(
              content: Text(context.messages.common.genericError),
            ));
          } else {
            Scaffold.of(context).showSnackBar(SnackBar(
              content: Text(context.messages.common.genericError),
              action: SnackBarAction(
                label: context.messages.common.retry,
                onPressed: widget.refresh,
              ),
            ));
          }
        }
        setState(() {});
      };
    }
  }

  @override
  void initState() {
    super.initState();
    _sub = _subscribe();
  }

  @override
  void didUpdateWidget(StatefulStreamBuilder<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    _sub?.cancel();
    _sub = _subscribe();
  }

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }

  Widget _buildError(BuildContext context) {
    return Center(
      child: Text(context.messages.common.genericError),
    );
  }

  @override
  Widget build(BuildContext context) {
    final stream = widget.stream;
    if (stream.lastValue == null) {
      if (stream.lastError == null) {
        if (widget.loadingBuilder != null) {
          return widget.loadingBuilder(context, widget.child);
        }
      } else {
        if (widget.errorBuilder == null) {
          if (widget.refresh == null) {
            return _buildError(context);
          } else {
            return RetryButton(
              onPressed: widget.refresh,
            );
          }
        } else {
          return widget.errorBuilder(context, widget.child, stream.lastError);
        }
      }
    }
    return widget.builder(context, widget.child, stream.lastValue);
  }
}

Widget _buildLoading(BuildContext context, _) {
  return LoadingIndicator();
}
