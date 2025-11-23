import '../../core/api_client.dart';
import '../models/room_model.dart';

class RoomRepo {
  final _api = ApiClient();

  Future<List<Room>> getRooms() async {
    final res = await _api.dio.get("/rooms");
    return (res.data as List).map((e) => Room.fromJson(e)).toList();
  }

  Future<void> addRoom(String name) async {
    await _api.dio.post("/rooms", data: {"name": name});
  }
}
