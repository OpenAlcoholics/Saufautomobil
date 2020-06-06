import 'dart:async';

import 'package:sam/data/dependency_model.dart';
import 'package:sam/domain/game/game_service.dart';
import 'package:sam/domain/game/game_state.dart';
import 'package:sam/view/common.dart';

class PlayerController {
  final ValueNotifier<List<String>> players = ValueNotifier(null);
  final ValueNotifier<bool> isEditing = ValueNotifier(false);
  StreamSubscription _playerSub;

  PlayerController() {
    _playerSub = _subscribeToPlayers();
  }

  StreamSubscription _subscribeToPlayers() {
    final playerState = service<GameState>().players;
    players.value = playerState.lastValue;
    return playerState.stream.listen((event) {
      players.value = event;
    });
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
    final players = this.players.value;
    await service<GameService>().updatePlayers(players);
  }

  Future<void> toggleEditing() async {
    final wasEditing = isEditing.value;
    if (wasEditing) {
      await _commitChanges();
      _playerSub.resume();
    } else {
      _playerSub.pause();
    }
    isEditing.value = !wasEditing;
  }

  void dispose() {
    _playerSub.cancel();
    players.dispose();
    isEditing.dispose();
  }
}
