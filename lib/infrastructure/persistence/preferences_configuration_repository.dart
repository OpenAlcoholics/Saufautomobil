import 'package:injectable/injectable.dart';
import 'package:sam/domain/model/game_configuration.dart';
import 'package:sam/domain/persistence/configuration_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _minKey = 'minimumSips';
const _maxKey = 'maximumSips';
const _remoteKey = 'isRemote';

@Injectable(as: ConfigurationRepository)
class PreferencesConfigurationRepository implements ConfigurationRepository {
  final SharedPreferences _preferences;

  PreferencesConfigurationRepository(this._preferences);

  @override
  Future<GameConfiguration> getConfiguration() async {
    final min = _preferences.getInt(_minKey);
    final max = _preferences.getInt(_maxKey);
    final isRemote = _preferences.getBool(_remoteKey);
    if (min != null && max != null && isRemote != null) {
      return GameConfiguration(
        minimumSips: min,
        maximumSips: max,
        isRemoteOnly: isRemote,
      );
    } else {
      return const GameConfiguration.defaultConfig();
    }
  }

  @override
  Future<void> updateConfiguration(GameConfiguration configuration) async {
    final futures = [
      _preferences.setInt(_minKey, configuration.minimumSips),
      _preferences.setInt(_maxKey, configuration.maximumSips),
      _preferences.setBool(_remoteKey, configuration.isRemoteOnly),
    ];
    await Future.wait(futures);
  }
}
