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

  UserModel copyWith({
  String? id,
  String? nameEn,
  String? nameAr,
  String? userName,
  String? email,
  String? nationalId,
  int? gender,
  String? passwordHash,
  String? photo,
  String? phoneNumber,
  String? address,
  String? birthDate,
  bool? isActive,
  int? type,
  dynamic salary,
  dynamic maxLevel,
  dynamic traineeLevel,
  String? qrCode,
  dynamic academyId,
  dynamic stableId,
  String? token,
  String? refreshToken,
}) {
  return UserModel(
    id: id ?? this.id,
    nameEn: nameEn ?? this.nameEn,
    nameAr: nameAr ?? this.nameAr,
    userName: userName ?? this.userName,
    email: email ?? this.email,
    nationalId: nationalId ?? this.nationalId,
    gender: gender ?? this.gender,
    passwordHash: passwordHash ?? this.passwordHash,
    photo: photo ?? this.photo,
    phoneNumber: phoneNumber ?? this.phoneNumber,
    address: address ?? this.address,
    birthDate: birthDate ?? this.birthDate,
    isActive: isActive ?? this.isActive,
    type: type ?? this.type,
    salary: salary ?? this.salary,
    maxLevel: maxLevel ?? this.maxLevel,
    traineeLevel: traineeLevel ?? this.traineeLevel,
    qrCode: qrCode ?? this.qrCode,
    academyId: academyId ?? this.academyId,
    stableId: stableId ?? this.stableId,
    token: token ?? this.token,
    refreshToken: refreshToken ?? this.refreshToken,
  );
}

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
