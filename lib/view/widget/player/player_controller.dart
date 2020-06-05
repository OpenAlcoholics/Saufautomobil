import 'package:sam/view/common.dart';

class PlayerController {
  final ValueNotifier<List<String>> players = ValueNotifier(null);

  PlayerController() {
    players.value = ["Björn", "Torben"];
  }

  Future<void> addPlayer(String newPlayer) async {
    final list = players.value.toList();
    final trimmed = newPlayer.trim();
    final lowerPlayer = trimmed.toLowerCase();
    for (final player in list) {
      if (player.toLowerCase() == lowerPlayer) {
        throw ArgumentError();
      }
    }
    list.add(trimmed);
    players.value = list;
  }

  Future<void> removePlayer(String player) async {
    final newPlayers = players.value.toList();
    newPlayers.remove(player);
    players.value = newPlayers;
  }

  void dispose() {
    players.dispose();
  }
}
