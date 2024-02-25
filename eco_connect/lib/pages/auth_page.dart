import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eco_connect/pages/home_page.dart';
import 'package:eco_connect/pages/login_or_register_page.dart';
import 'package:eco_connect/pages/onboarding_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // logged in
            if(snapshot.hasData) {
              final email = snapshot.data!.email!;

          return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
            future: FirebaseFirestore.instance.collection('Users').doc(email).get(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final userData = snapshot.data!.data();
                final isOnboarded = userData?['userHasCompletedOnboarding'] ?? false; // Check for null

                return isOnboarded ? const HomePage() : const OnBoardingPage();
              } else if (snapshot.hasError) {
                print('Error getting user data: ${snapshot.error}');
                return const Center(child: Text('Error loading user data'));
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          );
            }
          // not logged in
            else {
              return const LoginOrRegisterPage();
            }

        }
      )
    );
  }
}