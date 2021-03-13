import 'package:meta/meta.dart';
import 'package:sam/domain/model/card_spec.dart';

@immutable
class GameConfiguration {
  final Set<CardSpec> specs;

  const GameConfiguration({required this.specs});
}
