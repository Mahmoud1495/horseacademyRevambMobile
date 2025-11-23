import 'package:flutter/material.dart';
import 'package:horseacademy/presentation/Shared/DashboardScaffold.dart';
import '../../data/models/user_model.dart';
import '../../data/repo/room_repo.dart';

class AdminHome extends StatelessWidget {
  final UserModel user;
  final RoomRepo roomRepo = RoomRepo();

  AdminHome({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DashboardScaffold(
      user: user,
      title: "Admin Dashboard",
      body: FutureBuilder(
        future: roomRepo.getRooms(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());

          final rooms = snapshot.data!;
          return ListView.builder(
            itemCount: rooms.length,
            itemBuilder: (_, i) => ListTile(title: Text(rooms[i].name)),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addRoomDialog(context),
        child: Icon(Icons.add),
      ),
    );
  }

  _addRoomDialog(BuildContext context) {
    final c = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Add Room"),
        content: TextField(controller: c),
        actions: [
          TextButton(
            onPressed: () {
              roomRepo.addRoom(c.text);
              Navigator.pop(context);
            },
            child: Text("Save"),
          ),
        ],
      ),
    );
  }
}
