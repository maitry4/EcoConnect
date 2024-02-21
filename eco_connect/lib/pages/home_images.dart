import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eco_connect/components/image_post_ui.dart';
import 'package:eco_connect/helper/helper_method.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeImagePage extends StatefulWidget {
  const HomeImagePage({super.key});

  @override
  State<HomeImagePage> createState() => _HomeImagePageState();
}

class _HomeImagePageState extends State<HomeImagePage> {
  final currentUser = FirebaseAuth.instance.currentUser!;

  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  final username = FirebaseAuth.instance.currentUser != null ? FirebaseAuth.instance.currentUser!.email : 'something';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
          ),

      body: Center(
        child: Column(
          children: [
            // eco connect
            Expanded(
              child: StreamBuilder(
                stream:FirebaseFirestore.instance
                .collection("User Image Posts")
                .orderBy(
                  "TimeStamp",
                  descending: true)
                .snapshots(),
                builder: (context, snapshot) {
                  if(snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                      // get message
                      final post = snapshot.data!.docs[index];
                      return ImagePostUi(
                        message: post["description"], 
                        user: post["UserEmail"],
                        postId: post.id,
                        time: formatDate(post['TimeStamp']),
                        likes:List<String>.from(post['Likes'] ?? []),
                        commentCount: post['commentCount'],
                        imageUrl: post['PostImageURL'],
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
            
          ],
        ),
      )
    );
  }
}