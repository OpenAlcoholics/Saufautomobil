import 'package:sam/domain/model/user.dart';

abstract class UserRepository {
  Future<void> insertUser(User user);

  Future<User?> findUser(String userId);

  Future<Set<User>> getUsers();

  Future<void> updateUser(User user);

  Future<void> deleteUser(String userId);
}
