import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:horseacademy/core/api_client.dart';
import 'package:horseacademy/data/models/SessionModel.dart';
import 'package:horseacademy/data/models/user_model.dart';

class SessionsRepo {
  final _api = ApiClient();
  final FlutterSecureStorage storage = const FlutterSecureStorage();

  Future<List<SessionModel>> getSessionsByBundleId(String bundleId) async {
    final res = await _api.dio.get(
      'Timers/GetSessionsByBundleId?BundleId=$bundleId',
    );

    // Extract Data safely
    final data = res.data["Data"];

    if (data == null || data is! List) return [];

    return data.map<SessionModel>((e) => SessionModel.fromMap(e)).toList();
  }

  Future<List<SessionModel>> createTimers(List<SessionModel> selectedSessions) async {
    final userJson = await storage.read(key: "user");
    if (userJson != null) {
      final user = UserModel.fromJson(userJson);
      List<SessionModel> failedSessions = []; // List to keep track of failed sessions

      for (var session in selectedSessions) {
        final timerBody = {
          "traineeId": user.id, // Pass the traineeId
          "sessionId": session.id, // Use the sessionId
          "totalSeconds": 0, // Default value for total time
          "remainingSeconds": 0, // Initially remaining time equals total time
          "durationSeconds": 0, // Default value, will need to be calculated or set
          "elapsedSeconds": 0, // Initially, no time has elapsed
          "active": false, // Initially not active
          "done": false, // Initially not done
          "firedThresholds": [0] // Can be customized if needed
        };

        try {
          // Send the POST request to your endpoint
          final response = await _api.dio.post('Timers/AddTraineeTimer', data: timerBody);

          // Assuming the response contains the GUID of the created timer
          final data = response.data["Data"];
          if(!data['isSuccess']){
            failedSessions.add(session); 
          } // Replace with the actual response key from your API
          final timerGuid = data['id'];
          print('Timer created for session: ${session.id} with GUID: $timerGuid');
        } catch (e) {
          print('Error creating timer for session: ${session.id}, Error: $e');
          failedSessions.add(session); // Add to failed list
        }
      }

      return failedSessions; // Return failed sessions
    } else {
      return []; // No user found, return empty list
    }
  }
}
