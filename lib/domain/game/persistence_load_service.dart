import 'package:sam/data/dependency_model.dart';
import 'package:sam/domain/game/game_state.dart';

class PersistenceLoadService {
  Future<void> loadGame() async {
    final gameState = service<GameState>();
    gameState.players.addValue([]);
    gameState.isInitialized.addValue(true);
    // TODO implement
  }
}
