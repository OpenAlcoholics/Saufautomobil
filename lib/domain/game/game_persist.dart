import 'package:sam/data/dependency_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

const PLAYER_KEY = "currentPlayer";
const TURN_KEY = "currentTurn";
const ROUND_KEY = "currentRound";

class GamePersist {
  Future<void> storeCurrentPlayer(int currentPlayer) async {
    await service<SharedPreferences>().setInt(PLAYER_KEY, currentPlayer);
  }

  int loadCurrentPlayer() {
    return service<SharedPreferences>().getInt(PLAYER_KEY);
  }

  Future<void> storeCurrentTurn(int currentTurn) async {
    await service<SharedPreferences>().setInt(TURN_KEY, currentTurn);
  }

  int loadCurrentTurn() {
    return service<SharedPreferences>().getInt(TURN_KEY);
  }

  Future<void> storeCurrentRound(int currentRound) async {
    await service<SharedPreferences>().setInt(ROUND_KEY, currentRound);
  }

  int loadCurrentRound() {
    return service<SharedPreferences>().getInt(ROUND_KEY);
  }
}
