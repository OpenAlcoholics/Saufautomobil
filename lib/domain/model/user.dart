import 'package:sam/domain/util/annotations.dart';
import 'package:uuid/uuid.dart';

@immutable
class User {
  final String id;
  final String name;
  final bool isActive;

  const User._({
    required this.id,
    required this.name,
    required this.isActive,
  });

  factory User.create({
    required String name,
    bool isActive = true,
    String? id,
  }) {
    return User._(
      id: id ?? const Uuid().v4(),
      name: name,
      isActive: isActive,
    );
  }

  // ignore: avoid_positional_boolean_parameters
  User withActive(bool isActive) {
    return User._(
      id: id,
      name: name,
      isActive: isActive,
    );
  }

  User changeName(String name) {
    return User._(
      id: id,
      name: name,
      isActive: isActive,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is User &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          isActive == other.isActive;

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ isActive.hashCode;

  @override
  String toString() {
    return '{id: $id, name: $name, isActive: $isActive}';
  }
}
