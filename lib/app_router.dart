import 'package:flutter/material.dart';
import 'presentation/admin/admin_home.dart';
import 'presentation/trainee/trainee_home.dart';
import 'presentation/captain/captain_home.dart';
import '../data/models/user_model.dart';

class AppRouter {
   static logout(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(context, '/login', (_) => false);
  }
  static goToHome(BuildContext context, UserModel user) {
    switch (user.type) {
      case 3:
      Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (_) => AdminHome(user: user))); 
        //Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => AdminHome(user: user)));
        break;
      case 2:
      Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (_) => TraineeHome(user: user))); 
        //Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => TraineeHome(user: user)));
        break;
      case 1:
      Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (_) => CaptainHome(user: user))); 
        //Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => CaptainHome(user: user)));
        break;
      default:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Unknown user type")),
        );
    }
  }
}
