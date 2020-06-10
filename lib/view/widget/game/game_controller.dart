import 'package:sam/data/dependency_model.dart';
import 'package:sam/domain/game/game_service.dart';

class GameController {
  Future<void> advance() async {
    await service<GameService>().nextRound();
  }

  void dispose() {}
}
