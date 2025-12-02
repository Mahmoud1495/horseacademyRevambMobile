import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../core/api_client.dart';
import '../models/user_model.dart';

class UserRepo {
  final _api = ApiClient();
  final _storage = FlutterSecureStorage();


  // Login returns a full UserModel
  Future<String> updateUser(UserModel user) async {
    
    try {
      
  final response = await _api.dio.post(
    "User/EditUser",
    data: user.toJson(),
    options: Options(
    headers: {
      'Content-Type': 'application/json',
    },
    ),
  );

 final data = response.data;
    final values = data['Data'];

    final id = values['id'] ?? '' ;

    // Save user as JSON
    await _storage.write(key: "user", value: user.toJson());

    return id;
  
} on DioException catch (e) {
  print("DIO ERROR ===");

  // Server responded with error
  if (e.response != null) {
    print("STATUS CODE: ${e.response!.statusCode}");
    print("HEADERS: ${e.response!.headers}");
    print("DATA: ${e.response!.data}");
  } 
  // No response (connection failed, timeout, etc.)
  else {
    print("REQUEST ERROR: ${e.message}");
  }
  return '';
} catch (e) {
  print("UNEXPECTED ERROR: $e");
   return '';
}

   
  }

  // Logout
  Future<void> logout() async {
    await _storage.delete(key: "user");
  }


 }
