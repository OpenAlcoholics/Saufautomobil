import 'package:sam/data/dependency_model.dart';
import 'package:sam/domain/game/game_service.dart';

class ResetService {
  Future<void> resetGame() async {
    await service<GameService>().reset();
  }
}
