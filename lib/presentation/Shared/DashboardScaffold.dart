import 'package:flutter/material.dart';
import 'package:horseacademy/app_router.dart';
import '../../data/models/user_model.dart';
import '../../data/repo/auth_repo.dart';

class DashboardScaffold extends StatelessWidget {
  final UserModel user;
  final String title;
  final Widget body;
  final Widget? floatingActionButton; // <-- should be Widget? (optional)

  const DashboardScaffold({
    Key? key,
    required this.user,
    required this.title,
    required this.body,
    this.floatingActionButton, // <-- make sure it's a named parameter
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("$title - ${user.name}"),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await AuthRepo().logout();
              AppRouter.logout(context);
              // Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
            },
          ),
        ],
      ),
      body: body,
      floatingActionButton: floatingActionButton, // <-- pass it here
    );
  }
}
