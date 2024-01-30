import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});
  final user = FirebaseAuth.instance.currentUser!;

  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 11, 106, 14),
        actions: [
          IconButton(onPressed: signUserOut, icon: Icon(Icons.logout, color:Colors.white),)
          ]
          ),
      body: Center(
        child: Text("LOGGED IN! as "+user.email!),
        )
    );
  }
}