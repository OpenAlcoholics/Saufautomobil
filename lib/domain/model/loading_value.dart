import 'package:meta/meta.dart';

enum LoadingState {
  loading,
  error,
  success,
}

@immutable
abstract class LoadingValue<T, E> {
  final LoadingState state;

  T get value;

  E get error;

  const LoadingValue._(this.state);

  const factory LoadingValue.loading() = _LoadingValue;

  const factory LoadingValue.loaded(T value) = _LoadedValue;

  const factory LoadingValue.error(E error) = _ErrorValue;

  @Deprecated('Properly use the state')
  bool get isLoaded => state == LoadingState.success;
}

@immutable
class _LoadingValue<T, E> extends LoadingValue<T, E> {
  const _LoadingValue() : super._(LoadingState.loading);

  @override
  T get value => throw StateError('No value in state $state');

  @override
  E get error => throw StateError('No error in state $state');
}

@immutable
class _LoadedValue<T, E> extends LoadingValue<T, E> {
  @override
  final T value;

  const _LoadedValue(this.value) : super._(LoadingState.success);

  @override
  E get error => throw StateError('No error in state $state');
}

@immutable
class _ErrorValue<T, E> extends LoadingValue<T, E> {
  @override
  final E error;

  const _ErrorValue(this.error) : super._(LoadingState.error);

  @override
  T get value => throw StateError('No value in state $state');
}
