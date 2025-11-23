import 'dart:convert';

class UserModel {
  final String uid;
  final String name;
  final String email;
  final String role; // admin | trainee | captain
  final String token;
  final String refreshToken;
  final String? photo;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.role,
    required this.token,
    required this.refreshToken,
    this.photo,
  });

  Map<String, dynamic> toMap() => {
        "uid": uid,
        "name": name,
        "email": email,
        "role": role,
        "token": token,
        "refreshToken": refreshToken,
        "photo": photo,
      };

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      role: map['role'] ?? '',
      token: map['token'] ?? '',
      refreshToken: map['refreshToken'] ?? '',
      photo: map['photo'],
    );
  }

  String toJson() => jsonEncode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(jsonDecode(source));
}
