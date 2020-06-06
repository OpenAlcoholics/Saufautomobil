import 'package:sam/domain/repository.dart';
import 'package:sqflite/sqflite.dart';

const TABLE_NAME = "players";
const COLUMN_INDEX = "list_index";
const COLUMN_NAME = "name";

class PlayerRepository implements Repository {
  final Database _connection;

  PlayerRepository(this._connection);

  @override
  Future<void> createIfNotExists() async {
    await _connection.execute("""
    CREATE TABLE IF NOT EXISTS $TABLE_NAME (
        $COLUMN_INDEX INTEGER UNIQUE NOT NULL, 
        $COLUMN_NAME TEXT PRIMARY KEY
    )
    """);
  }

  Future<void> setPlayers(List<String> players) async {
    await _connection.delete(TABLE_NAME);
    if (players.isEmpty) {
      return;
    }
    final batch = _connection.batch();
    for (var index = 0; index < players.length; ++index) {
      batch.insert(TABLE_NAME, {
        COLUMN_INDEX: index,
        COLUMN_NAME: players[index],
      });
    }
    await batch.commit();
  }

  Future<List<String>> loadPlayers() async {
    final queryResult = await _connection.query(TABLE_NAME);
    final players = List<String>(queryResult.length);
    for (final entry in queryResult) {
      final index = entry[COLUMN_INDEX];
      final name = entry[COLUMN_NAME];
      players[index] = name;
    }
    return players;
  }
}
