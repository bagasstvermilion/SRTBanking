import '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.uid,
    required super.email,
    required super.fullName,
  });

  factory UserModel.fromFirestore(Map<String, dynamic> data, String uid) {
    return UserModel(
      uid: uid,
      email: data['email'] ?? '',
      fullName: data['fullname'] ?? '',
    );
  }

  Map<String, dynamic> toMap() => {
    'email': email,
    'fullName': fullName,
    'createdAt': DateTime.now().toIso8601String(),
  };
}
