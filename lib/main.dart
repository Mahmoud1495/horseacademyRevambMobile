import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'presentation/auth/login_screen.dart';

void main() async {
  // Ensure Flutter bindings are initialized before using any platform channels
  WidgetsFlutterBinding.ensureInitialized();
  //  final storage = FlutterSecureStorage();
  // await storage.delete(key: "user"); // clear old invalid user
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

   
      // Default screen when app starts
      home: LoginScreen(),

      // Add named routes
      routes: {
        '/login': (context) => LoginScreen(),
      },
    );
  }
}
