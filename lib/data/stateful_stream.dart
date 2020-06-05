import 'dart:async';

abstract class StatefulStream<T> {
  Stream<T> get stream;

  T get lastValue;

  dynamic get lastError;
}

abstract class UpdatableStatefulStream<T> implements StatefulStream<T> {
  factory UpdatableStatefulStream() {
    return _UpdatableStatefulStream();
  }

  void addValue(T value);

  void addError(dynamic error);
}

class _UpdatableStatefulStream<T> implements UpdatableStatefulStream<T> {
  final _controller = StreamController<T>.broadcast();

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
