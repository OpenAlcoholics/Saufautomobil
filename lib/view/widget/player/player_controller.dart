import 'package:sam/view/common.dart';

class PlayerController {
  final ValueNotifier<List<String>> players = ValueNotifier(null);
  final ValueNotifier<bool> isEditing = ValueNotifier(false);

  PlayerController() {
    players.value = ["Björn", "Torben"];
  }

  Future<void> addPlayer(String newPlayer) async {
    if (!isEditing.value) {
      throw StateError('Not in editing mode');
    }
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
    if (!isEditing.value) {
      throw StateError('Not in editing mode');
    }
    final newPlayers = players.value.toList();
    newPlayers.remove(player);
    players.value = newPlayers;
  }

  Future<void> _commitChanges() async {
    // TODO commit changes
  }

  Future<void> toggleEditing() async {
    final wasEditing = isEditing.value;
    await _commitChanges();
    isEditing.value = !wasEditing;
  }

  void dispose() {
    players.dispose();
    isEditing.dispose();
  }
}
