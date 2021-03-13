import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:meta/meta.dart';
import 'package:sam/domain/api/card_spec_service.dart';
import 'package:sam/domain/model/card_spec.dart';
import 'package:sam/domain/model/game_configuration.dart';
import 'package:sam/domain/model/game_state.dart';
import 'package:sam/domain/model/loading_value.dart';
import 'package:sam/domain/persistence/card_spec_repository.dart';

enum CardSpecLoadingError {
  ioError,
  parsingError,
}

@immutable
class WelcomeState {
  final LoadingValue<GameState?, void> resumableState;
  final LoadingValue<GameConfiguration, CardSpecLoadingError> newGameConfig;

  const WelcomeState._({
    required this.resumableState,
    required this.newGameConfig,
  });

  const WelcomeState.loading()
      : resumableState = const LoadingValue.loading(),
        newGameConfig = const LoadingValue.loading();

  WelcomeState withValue({
    LoadingValue<GameState?, void>? resumableState,
    LoadingValue<GameConfiguration, CardSpecLoadingError>? newGameConfig,
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
  final LoadingValue<GameConfiguration, CardSpecLoadingError> configuration;

  _GameConfigurationLoaded(this.configuration);
}

class RetryNewGame extends _WelcomeEvent {}

class _ResumableGameLoaded extends _WelcomeEvent {
  final GameState? state;

  _ResumableGameLoaded(this.state);
}

@injectable
class WelcomeBloc extends Bloc<_WelcomeEvent, WelcomeState> {
  final CardSpecLoader _loader;

  WelcomeBloc(
    this._loader,
    // ignore: prefer_const_constructors
  ) : super(WelcomeState.loading()) {
    add(_InitEvent());
  }

  Future<void> _loadResumableGame() async {
    add(_ResumableGameLoaded(null));
  }

  Future<void> _loadGameConfiguration() async {
    try {
      final specs = await _loader();
      add(_GameConfigurationLoaded(
        LoadingValue.loaded(
          GameConfiguration(
            specs: specs,
          ),
        ),
      ));
    } on _CardSpecLoadingException catch (e) {
      add(_GameConfigurationLoaded(
        LoadingValue.error(e.error),
      ));
    }
  }

  @override
  Stream<WelcomeState> mapEventToState(_WelcomeEvent event) async* {
    if (event is _InitEvent) {
      _loadResumableGame();
      _loadGameConfiguration();
    } else if (event is RetryNewGame) {
      yield state.withValue(
        // ignore: prefer_const_constructors
        newGameConfig: LoadingValue.loading(),
      );
      _loadGameConfiguration();
    } else if (event is _GameConfigurationLoaded) {
      yield state.withValue(
        newGameConfig: event.configuration,
      );
    } else if (event is _ResumableGameLoaded) {
      yield state.withValue(
        resumableState: LoadingValue.loaded(event.state),
      );
    }
  }
}

class _CardSpecLoadingException implements Exception {
  final CardSpecLoadingError error;

  _CardSpecLoadingException(this.error);
}

@injectable
class CardSpecLoader {
  final Logger logger;
  final CardSpecService service;
  final CardSpecRepository repo;

  CardSpecLoader(this.logger, this.service, this.repo);

  Future<Set<CardSpec>> call() async {
    try {
      final dtos = await service();
      final specs = dtos.map((e) => e.toModel()).toSet();
      await repo.replaceSpecs(specs);
      return specs;
    } on CardSpecServiceException catch (e) {
      logger.e('Could not fetch newest CardSpecs', e);
      final specs = await repo.getSpecs();
      if (specs.isEmpty) {
        throw _CardSpecLoadingException(CardSpecLoadingError.ioError);
      } else {
        return specs;
      }
    }
  }
}
