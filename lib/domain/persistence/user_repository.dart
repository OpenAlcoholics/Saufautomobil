import 'package:sam/domain/model/user.dart';

abstract class UserRepository {
  Future<void> insertUser(User user);

  Future<void> deleteUser(User user);

  Future<void> updateUser(User user);

  Future<Set<User>> getUsers(User user);
}
