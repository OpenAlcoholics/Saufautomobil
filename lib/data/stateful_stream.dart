import 'dart:async';

abstract class StatefulStream<T> {
  Stream<T> get stream;

  T get lastValue;

  dynamic get lastError;
}

abstract class UpdatableStatefulStream<T> implements StatefulStream<T> {
  factory UpdatableStatefulStream([T initialValue]) {
    return _UpdatableStatefulStream(initialValue);
  }

  void addValue(T value);

  void addError(dynamic error);
}

class _UpdatableStatefulStream<T> implements UpdatableStatefulStream<T> {
  final _controller = StreamController<T>.broadcast();

  _UpdatableStatefulStream([T initialValue]) {
    lastValue = initialValue;
  }

  @override
  Stream<T> get stream => _controller.stream;

  @override
  dynamic lastError;

  @override
  T lastValue;

  @override
  void addError(error) {
    lastError = error;
    _controller.addError(error);
  }

  @override
  void addValue(T value) {
    lastError = null;
    lastValue = value;
    _controller.add(value);
  }
}
