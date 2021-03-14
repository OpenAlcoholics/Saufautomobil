import 'package:sam/domain/model/game_configuration.dart';

abstract class ConfigurationRepository {
  Future<void> updateConfiguration(GameConfiguration configuration);

  Future<GameConfiguration> getConfiguration();
}
