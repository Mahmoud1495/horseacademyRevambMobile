import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:horseacademy/data/models/user_model.dart';
import 'app_config.dart';

class ApiClient {
  final Dio dio = Dio(BaseOptions(
    baseUrl: AppConfig.baseUrl,
    connectTimeout: Duration(seconds: 10),
    receiveTimeout: Duration(seconds: 10),
  ));

  final FlutterSecureStorage storage = FlutterSecureStorage();

  ApiClient() {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final userJson = await storage.read(key: "user");
          if (userJson != null) {
            final user = UserModel.fromJson(userJson);
            if (user.token.isNotEmpty) {
              options.headers['Authorization'] = "Bearer ${user.token}";
            }
          }
          return handler.next(options);
        },
      ),
    );
  }
}
