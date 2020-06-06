import 'package:sqflite/sqflite.dart';

class GameRepository {
  final Database _connection;

  GameRepository(this._connection);

  Future<void> createIfNotExists() {
    // TODO implement
  }

  Future<void> close() {
    return _connection.close();
  }
}
