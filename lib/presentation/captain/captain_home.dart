import 'package:flutter/material.dart';
import 'package:horseacademy/presentation/Shared/DashboardScaffold.dart';
import '../../data/models/user_model.dart';

class CaptainHome extends StatelessWidget {
  final UserModel user;

  CaptainHome({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DashboardScaffold(
      user: user,
      title: "Captain Dashboard",
      body: Column(
        children: [
          ListTile(title: Text("Assigned Trainees"), onTap: () {}),
          ListTile(title: Text("Start Training"), onTap: () {}),
        ],
      ),
    );
  }
}
