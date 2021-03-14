import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:sam/domain/model/game_state.dart';
import 'package:sam/domain/model/loading_value.dart';

abstract class _ResumableLoadEvent {}

class _InitEvent extends _ResumableLoadEvent {}

@injectable
class ResumableLoad
    extends Bloc<_ResumableLoadEvent, LoadingValue<GameState?, void>> {
  ResumableLoad() : super(const LoadingValue.loading()) {
    add(_InitEvent());
  }

  @override
  Stream<LoadingValue<GameState?, void>> mapEventToState(
      _ResumableLoadEvent event) async* {
    if (event is _InitEvent) {
      await Future.delayed(const Duration(seconds: 2));
      yield LoadingValue.loaded(GameState());
      // TODO implement resuming
    }
  }
}
