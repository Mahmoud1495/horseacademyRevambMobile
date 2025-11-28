import 'dart:convert';

class UserModel {
  final String id;
  final String? nameEn;
  final String? nameAr;
  final String? userName;
  final String email;
  final String? nationalId;
  final int? gender;
  final String? passwordHash;
  final String? photo;
  final String? phoneNumber;
  final String? address;
  final String? birthDate;
  final bool? isActive;
  final int? type;
  final dynamic salary;
  final dynamic maxLevel;
  final dynamic traineeLevel;
  final String? qrCode;
  final dynamic academyId;
  final dynamic stableId;
  final String token;
  final String refreshToken;

  UserModel({
    required this.id,
    this.nameEn,
    this.nameAr,
    this.userName,
    required this.email,
    this.nationalId,
    this.gender,
    this.passwordHash,
    this.photo,
    this.phoneNumber,
    this.address,
    this.birthDate,
    this.isActive,
    this.type,
    this.salary,
    this.maxLevel,
    this.traineeLevel,
    this.qrCode,
    this.academyId,
    this.stableId,
    required this.token,
    required this.refreshToken,
  });

  Map<String, dynamic> toMap() => {
        "id": id,
        "nameEn": nameEn,
        "nameAr": nameAr,
        "userName": userName,
        "email": email,
        "nationalId": nationalId,
        "gender": gender,
        "passwordHash": passwordHash,
        "photo": photo,
        "phoneNumber": phoneNumber,
        "address": address,
        "birthDate": birthDate,
        "isActive": isActive,
        "type": type,
        "salary": salary,
        "maxLevel": maxLevel,
        "traineeLevel": traineeLevel,
        "qrCode": qrCode,
        "academyId": academyId,
        "stableId": stableId,
        "token": token,
        "refreshToken": refreshToken,
      };

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? '',
      nameEn: map['nameEn'],
      nameAr: map['nameAr'],
      userName: map['userName'],
      email: map['email'] ?? '',
      nationalId: map['nationalId'],
      gender: map['gender'],
      passwordHash: map['passwordHash'],
      photo: map['photo'],
      phoneNumber: map['phoneNumber'],
      address: map['address'],
      birthDate: map['birthDate'],
      isActive: map['isActive'],
      type: map['type'],
      salary: map['salary'],
      maxLevel: map['maxLevel'],
      traineeLevel: map['traineeLevel'],
      qrCode: map['qrCode'],
      academyId: map['academyId'],
      stableId: map['stableId'],
      token: map['token'] ?? '',
      refreshToken: map['refreshToken'] ?? '',
    );
  }

  String toJson() => jsonEncode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(jsonDecode(source));
}
