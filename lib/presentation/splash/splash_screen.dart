import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../data/models/user_model.dart';
import '../../app_router.dart';
import '../auth/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final storage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _checkUser();
  }

  Future<void> _checkUser() async {
    await Future.delayed(const Duration(seconds: 2)); // Splash delay

    final userJson = await storage.read(key: "user");

    if (userJson != null) {
      try {
        final user = UserModel.fromJson(userJson);
        if (!_isTokenExpired(user.token)) {
          // Navigate to Home
          AppRouter.goToHome(context, user);
          return;
        } else {
          await storage.delete(key: "user");
        }
      } catch (e) {
        await storage.delete(key: "user");
      }
    }

    // Fallback to Login
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => LoginScreen()),
    );
  }

  bool _isTokenExpired(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) return true;
      final payload =
          jsonDecode(utf8.decode(base64Url.decode(base64Url.normalize(parts[1]))));
      final exp = payload['exp'] as int;
      final now = DateTime.now().toUtc().millisecondsSinceEpoch ~/ 1000;
      return now >= exp;
    } catch (_) {
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Logo - same style as login page
            Container(
              height: size.height * 0.18,
              width: size.height * 0.18,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
                image: const DecorationImage(
                  image: AssetImage('lib/assets/Logo.jpg'), // same as login
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: size.height * 0.04),

            // App title
            Text(
              "Horse Academy",
              style: TextStyle(
                fontSize: size.height * 0.035,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: size.height * 0.02),

            // Loading indicator
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(Colors.black87),
            ),
          ],
        ),
      ),
    );
  }
}
