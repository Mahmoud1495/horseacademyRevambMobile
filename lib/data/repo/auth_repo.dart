import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../core/api_client.dart';
import '../models/user_model.dart';

class AuthRepo {
  final _api = ApiClient();
  final _storage = FlutterSecureStorage();


  // Login returns a full UserModel
  Future<UserModel> login(String email, String password) async {
    final response = await _api.dio.post(
      "Account/AuthenticateUser",
      data: {
        "userName": email,
        "password": password,
      },
    );

    final data = response.data;
    final values = data['Data'];

    final user = UserModel(
  id: values['id'] ?? '',
  nameEn: values['nameEn'],
  nameAr: values['nameAr'],
  userName: values['userName'],
  email: values['email'] ?? '',
  nationalId: values['nationalId'],
  gender: values['gender'],
  passwordHash: values['passwordHash'],
  photo: values['photo'],
  phoneNumber: values['phoneNumber'],
  address: values['address'],
  birthDate: values['birthDate'],
  isActive: values['isActive'],
  type: values['type'], // old: userType
  salary: values['salary'],
  maxLevel: values['maxLevel'],
  traineeLevel: values['traineeLevel'],
  qrCode: values['qrCode'],
  academyId: values['academyId'],
  stableId: values['stableId'],
  token: values['token'] ?? '',
  refreshToken: values['refreshToken'] ?? '',
);

    // Save user as JSON
    await _storage.write(key: "user", value: user.toJson());

    return user;
  }

  // Logout
  Future<void> logout() async {
    await _storage.delete(key: "user");
  }

  // Load user from storage
  Future<UserModel?> getCurrentUser() async {
    final raw = await _storage.read(key: "user");
    if (raw == null) return null;

    return UserModel.fromJson(raw);
  }

//   // Map backend user type
//   String mapUserType(int? type) {
//     switch (type) {
//       case 3:
//         return 'admin';
//       case 2:
//         return 'trainee';
//       case 1:
//         return 'captain';
//       default:
//         return 'unknown';
//     }
//   }
 }
