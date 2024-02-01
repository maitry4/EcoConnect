import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eco_connect/components/my_textfield.dart';
import 'package:eco_connect/components/post_ui.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final currentUser = FirebaseAuth.instance.currentUser!;

  final textController = TextEditingController();

  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  // post a message
  void postMessage() {
    // only post if there is something in the text field
    if(textController.text.isNotEmpty) {
      FirebaseFirestore.instance.collection("User Posts").add({
        'UserEmail': currentUser.email,
        'Message': textController.text,
        'TimeStamp': Timestamp.now(),
      });
    }

    // clear the text field
    setState(() {
      textController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        actions: [
          IconButton(onPressed: signUserOut, icon: Icon(Icons.logout, color:Theme.of(context).appBarTheme.foregroundColor,))
          ]
          ),
      body: Center(
        child: Column(
          children: [
            // post message
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: Row(
                children: [
                  Expanded(
                    // text field
                    child: MyTextField(
                      controller: textController,
                      hintText: 'Inspire People with What\'s on Your Mind...',
                      obscureText: false,
                    ),
                  ),
              
                  // post message button
                  IconButton(onPressed: postMessage,
                  icon: Icon(Icons.arrow_circle_up))
                ]
              ),
            ),

            // eco connect
            Expanded(
              child: StreamBuilder(
                stream:FirebaseFirestore.instance
                .collection("User Posts")
                .orderBy(
                  "TimeStamp",
                  descending: false)
                .snapshots(),
                builder: (context, snapshot) {
                  if(snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                      // get message
                      final post = snapshot.data!.docs[index];
                      return PostUi(
                        message: post["Message"], 
                        user: post["UserEmail"],
                        );
                    },
                   );
                  }
                  else if(snapshot.hasError) {
                    return Center(child: Text('Error${snapshot.error}'));
                  }
                  return const Center(child: CircularProgressIndicator(),);
                },
                ),
              ),
            

            // logged in as
            Text("Logged In as: "+currentUser.email!, style: TextStyle(color: Colors.grey),),

            const SizedBox(height: 50,),
          ],
        ),
      )
    );
  }
}