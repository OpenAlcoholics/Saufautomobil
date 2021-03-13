import 'package:meta/meta.dart';

@immutable
class LoadingValue<T> {
  final bool isLoaded;
  final T? _value;

  T get value {
    if (isLoaded) {
      return _value!;
    } else {
      throw StateError("Can't get value if isLoaded is false");
    }
  }

  const LoadingValue.loaded(this._value) : isLoaded = true;

  const LoadingValue.loading()
      : isLoaded = false,
        _value = null;
}
