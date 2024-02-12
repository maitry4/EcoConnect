import 'package:eco_connect/pages/auth_page.dart';
import 'package:eco_connect/theme/light_theme.dart';
// import 'package:eco_connect/theme/dark_theme.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme:lightTheme,
      // darkTheme: darkTheme,
      debugShowCheckedModeBanner: false,
      home: AuthPage(),
    );
  }
}