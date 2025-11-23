import 'package:flutter/material.dart';
import '../../data/repo/auth_repo.dart';
import '../../app_router.dart';

class LoginScreen extends StatelessWidget {
  final emailC = TextEditingController();
  final passC = TextEditingController();
  final authRepo = AuthRepo();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Login")),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(controller: emailC, decoration: InputDecoration(labelText: "Email")),
            TextField(controller: passC, obscureText: true, decoration: InputDecoration(labelText: "Password")),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {

  // final result = await authRepo.login(emailC.text, passC.text);

final user = await authRepo.login(emailC.text, passC.text);
AppRouter.goToHome(context, user); // now passes UserModel
},
              child: Text("Login"),
            )
          ],
        ),
      ),
    );
  }
}
