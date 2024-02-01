import 'package:eco_connect/components/text_box.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  // get the current user
  final currentUser = FirebaseAuth.instance.currentUser!;

  // edit field
  Future<void> editField(String field) async {

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile Page"),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      ),

      body: ListView(
        children: [
          const SizedBox(height: 50,),

          // profile pic
          Icon(
            Icons.person,
            size: 72,
            color: Theme.of(context).appBarTheme.backgroundColor,
          ),

          const SizedBox(height: 10,),
          // user email
          Text(
            currentUser.email!,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey[700]),
          ),

          const SizedBox(height: 50,),

          // user details
          Padding(
            padding: const EdgeInsets.only(left: 25.0),
            child: Text('My Details', 
            style: TextStyle(color: Colors.grey[600]),
           ),
          ),

          // username
          MyTextBox(
            text: 'maitry4',
            sectionName: 'username',
            onPressed: () => editField('username'),
          ),

          // bio
          MyTextBox(
            text: 'empty bio',
            sectionName: 'bio',
            onPressed: () => editField('bio'),
          ),

          const SizedBox(height: 50,),

          // users posts
          Padding(
            padding: const EdgeInsets.only(left: 30.0),
            child: Text('My Posts', 
            style: TextStyle(color: Colors.grey[600]),
           ),
          ),
        ],
      ),
    );
  }
}