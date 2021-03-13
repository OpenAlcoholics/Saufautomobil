import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';
import 'package:sam/domain/model/game_configuration.dart';
import 'package:sam/domain/model/game_state.dart';
import 'package:sam/domain/model/loading_value.dart';

@immutable
class WelcomeState {
  final LoadingValue<GameState?> resumableState;
  final LoadingValue<GameConfiguration> newGameConfig;

  const WelcomeState._({
    required this.resumableState,
    required this.newGameConfig,
  });

  const WelcomeState.loading()
      : resumableState = const LoadingValue.loading(),
        newGameConfig = const LoadingValue.loading();

  WelcomeState withValue({
    LoadingValue<GameState?>? resumableState,
    LoadingValue<GameConfiguration>? newGameConfig,
  }) {
    return WelcomeState._(
      resumableState: resumableState ?? this.resumableState,
      newGameConfig: newGameConfig ?? this.newGameConfig,
    );
  }

  @override
  String toString() {
    return '{resumableState: $resumableState, newGameConfig: $newGameConfig}';
  }
}

abstract class _WelcomeEvent {}

class _InitEvent extends _WelcomeEvent {}

class _GameConfigurationLoaded extends _WelcomeEvent {
  final GameConfiguration configuration;

  _GameConfigurationLoaded(this.configuration);
}

class _ResumableGameLoaded extends _WelcomeEvent {
  final GameState? state;

  _ResumableGameLoaded(this.state);
}

@injectable
class WelcomeBloc extends Bloc<_WelcomeEvent, WelcomeState> {
  WelcomeBloc() : super(const WelcomeState.loading()) {
    add(_InitEvent());
  }

  Future<void> _loadResumableGame() async {
    add(_ResumableGameLoaded(null));
  }

  Future<void> _loadGameConfiguration() async {
    add(_GameConfigurationLoaded(const GameConfiguration(
      specs: [],
    )));
  }

  @override
  Stream<WelcomeState> mapEventToState(_WelcomeEvent event) async* {
    if (event is _InitEvent) {
      _loadResumableGame();
      _loadGameConfiguration();
    } else if (event is _GameConfigurationLoaded) {
      yield state.withValue(
        newGameConfig: LoadingValue.loaded(event.configuration),
      );
    } else if (event is _ResumableGameLoaded) {
      yield state.withValue(
        resumableState: LoadingValue.loaded(event.state),
      );
    }
  }
}
