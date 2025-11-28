import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:horseacademy/core/app_config.dart';
import 'package:horseacademy/data/models/user_model.dart';


class ApiClient {
  final Dio dio = Dio(BaseOptions(
    baseUrl: AppConfig.baseUrl,
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
  ));

  final FlutterSecureStorage storage = const FlutterSecureStorage();

  ApiClient() {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final userJson = await storage.read(key: "user");
          if (userJson != null) {
            // final userMap = jsonDecode(userJson);
            final user = UserModel.fromJson(userJson);

            if (_isTokenExpired(user.token)) {
              final refreshedUser = await _refreshToken(user);
              if (refreshedUser != null) {
                options.headers['Authorization'] = 'Bearer ${refreshedUser.token}';
              } else {
                // Session expired
                await storage.delete(key: "user");
                return handler.reject(
                  DioError(
                    requestOptions: options,
                    error: "Session expired",
                    type: DioErrorType.cancel,
                  ),
                );
              }
            } else {
              options.headers['Authorization'] = 'Bearer ${user.token}';
            }
          }
          return handler.next(options);
        },
      ),
    );
  }

  bool _isTokenExpired(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) return true;
      final payload =
          jsonDecode(utf8.decode(base64Url.decode(base64Url.normalize(parts[1]))));
      final exp = payload['exp'] as int;
      final now = DateTime.now().toUtc().millisecondsSinceEpoch ~/ 1000;
      return now >= exp;
    } catch (_) {
      return true;
    }
  }

  Future<UserModel?> _refreshToken(UserModel user) async {
    try {
      final response = await dio.post('Account/RefreshToken', data: {
        'accessToken': user.token,
        'refreshToken': user.refreshToken,
      });

      final values = response.data['Data'];
      final refreshedUser = UserModel(
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


      await storage.write(key: "user", value: jsonEncode(refreshedUser.toJson()));
      return refreshedUser;
    } catch (_) {
      return null;
    }
  }
}
