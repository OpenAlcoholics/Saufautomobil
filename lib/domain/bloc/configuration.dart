import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:sam/domain/model/game_configuration.dart';
import 'package:sam/domain/persistence/configuration_repository.dart';

abstract class _ConfigurationEvent {}

class ChangeMinimum implements _ConfigurationEvent {
  final int? minimum;

  const ChangeMinimum({required this.minimum});
}

class ChangeMaximum implements _ConfigurationEvent {
  final int? maximum;

  const ChangeMaximum({required this.maximum});
}

class ChangeRemote implements _ConfigurationEvent {
  final bool isRemoteOnly;

  const ChangeRemote({required this.isRemoteOnly});
}

const _defaultConfig = GameConfiguration.defaultConfig();

@injectable
class ConfigurationBloc extends Bloc<_ConfigurationEvent, GameConfiguration> {
  final ConfigurationRepository _repo;

  ConfigurationBloc(@factoryParam GameConfiguration? state, this._repo)
      : super(state ?? _defaultConfig);

  @override
  Stream<GameConfiguration> mapEventToState(_ConfigurationEvent event) async* {
    final GameConfiguration config;
    if (event is ChangeMinimum) {
      config = state.copy(
        minimumSips: event.minimum ?? _defaultConfig.minimumSips,
      );
    } else if (event is ChangeMaximum) {
      config = state.copy(
        maximumSips: event.maximum ?? _defaultConfig.maximumSips,
      );
    } else if (event is ChangeRemote) {
      config = state.copy(isRemoteOnly: event.isRemoteOnly);
    } else {
      throw ArgumentError.value(event, 'event', 'Unknown event');
    }
    yield config;
    _repo.updateConfiguration(config);
  }
}
