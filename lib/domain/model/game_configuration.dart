import 'package:meta/meta.dart';

@immutable
class GameConfiguration {
  final int minimumSips;
  final int maximumSips;
  final bool isRemoteOnly;

  const GameConfiguration({
    required this.minimumSips,
    required this.maximumSips,
    required this.isRemoteOnly,
  });

  const GameConfiguration.defaultConfig()
      : minimumSips = 1,
        maximumSips = 6,
        isRemoteOnly = false;

  GameConfiguration copy({
    int? minimumSips,
    int? maximumSips,
    bool? isRemoteOnly,
  }) {
    return GameConfiguration(
      minimumSips: minimumSips ?? this.minimumSips,
      maximumSips: maximumSips ?? this.maximumSips,
      isRemoteOnly: isRemoteOnly ?? this.isRemoteOnly,
    );
  }
}
