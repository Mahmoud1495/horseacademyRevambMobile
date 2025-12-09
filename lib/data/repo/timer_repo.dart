import 'package:dio/dio.dart';
import '../../core/api_client.dart';

class TimerRepo {
  final _api = ApiClient();

  Future<void> checkTimers(id) async {
     final res = await _api.dio.post(
    "Timers/Timercheck/check",
    data: '"$id"', // wrap in quotes to send as raw JSON string
    options: Options(
      headers: {"Content-Type": "application/json"},
    ),
  );
  }
}
