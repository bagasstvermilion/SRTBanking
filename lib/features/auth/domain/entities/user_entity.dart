// domain/entities/user_entity.dart
class UserEntity {
  final String uid;
  final String email;
  final String fullName;

  const UserEntity({
    required this.uid,
    required this.email,
    required this.fullName,
  });
}
