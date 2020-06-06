import 'package:sam/data/dependency_model.dart';
import 'package:sam/domain/game/game_state.dart';

class PersistenceLoadService {
  Future<void> loadGame() async {
    final gameState = service<GameState>();
    //await Future.delayed(Duration(seconds: 3));
    gameState.isInitialized.addValue(true);
    // TODO implement
  }
}
