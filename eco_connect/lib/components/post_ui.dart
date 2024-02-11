import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eco_connect/components/comment.dart';
import 'package:eco_connect/components/comment_button.dart';
import 'package:eco_connect/components/like_button.dart';
import 'package:eco_connect/helper/helper_method.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PostUi extends StatefulWidget {
  final String message;
  final String user;
  final String postId;
  final String time;
  final List<String> likes;

  const PostUi({
    super.key, 
    required this.message,
    required this.user,
    required this.postId,
    required this.time,
    required this.likes,
    });

  @override
  State<PostUi> createState() => _PostUiState();
}

class _PostUiState extends State<PostUi> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  bool isLiked = false;

  // comment text controller
  final _commentTextController = TextEditingController();

  // doubt 
  @override
  void initState() {
    super.initState();
    isLiked = widget.likes.contains(currentUser.email);
  }

  // toggle like
  void toggleLike() {
    setState(() {
      isLiked = !isLiked;
    });

    // Acess the document in Firebase
    DocumentReference postRef = FirebaseFirestore.instance.collection('User Posts').doc(widget.postId);

    if(isLiked) {
      // if the post is now liked, add the user's email to the 'Likes' field
      postRef.update({
        'Likes': FieldValue.arrayUnion([currentUser.email]),
      });
    } else {
      // if the post is now unliked, remove the user's email from the 'Likes' field
      postRef.update({
        'Likes': FieldValue.arrayRemove([currentUser.email]),
      });

    }
  }
  
  // add a comment
  void addComment(String commentText) {
    // write comment to the firestore
    FirebaseFirestore.instance.collection("User Posts").doc(widget.postId).collection("Comments").add({
      "CommentText": commentText,
      "CommentedBy":currentUser.email,
      "CommentTime":Timestamp.now(), //format this later
    });
  }

  // show dialog box for adding a comment
  void showCommentDialog() {
    showDialog(
      context:context,
      builder: (context) =>
      AlertDialog(
        title: Text("Add Comment"),
        content: TextField(
          autocorrect: true,
          controller: _commentTextController,
          decoration: InputDecoration(hintText: "Write a comment..."),
        ),
        actions: [
          // cancel button
          TextButton(
            onPressed: () {
              // pop the box
              Navigator.pop(context);

              // clear the controller
              _commentTextController.clear();

            },
            child: Text("Cancel")),
          // save button
          TextButton(
            onPressed: () {
              // add comment 
              addComment(_commentTextController.text);
              // clear the controller
              _commentTextController.clear();
              // pop the box
              Navigator.pop(context);

            }, 
            child: Text("Post")),
        ],
      ),);

  }
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color:Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      margin:EdgeInsets.only(top: 25, left: 25, right: 25),
      padding: EdgeInsets.all(25),
      // post ui
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // messages and user email
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // message
              Text(widget.message),
              const SizedBox(height: 5,),
              // user
               Row(
                children: [
                  Text(widget.user,
                  style: TextStyle(color: Colors.grey[400]),),
                  Text(' . ',
                  style: TextStyle(color: Colors.grey[400]),),
                  Text(widget.time,
                  style: TextStyle(color: Colors.grey[400]),),
                ],
              ),
          ],),

          const SizedBox(height: 20,),

          // buttons
          Row(
            children: [
              // LIKE    
              Column(
                children: [
                  // like button
                  LikeButton(
                    isLiked: isLiked, 
                    onTap: toggleLike,
                  ),
                  
                  const SizedBox(height: 5),
              
                  // like count
                  Text(
                    widget.likes.length.toString(),
                    style: TextStyle(color: Colors.grey),
                    ),
                ],
              ),

              // COMMENT
              Column(
                children: [
                  // comment button
                  CommentButton(
                    onTap: showCommentDialog,
                  ),
                  
                  const SizedBox(height: 5),
              
                  // comment count
                  // *****************YET TO IMPLEMENT****************
                  Text(
                    "0",
                    style: TextStyle(color: Colors.grey),
                    ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 10),

          // comments under the post
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
            .collection("User Posts")
            .doc(widget.postId)
            .collection("Comments")
            .orderBy("CommentTime", descending: true)
            .snapshots(), 
            builder: (context, snapshot) {
              // show the loading circle
              if(!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator(),);
              }
              return ListView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: snapshot.data!.docs.map((doc){
                  // get the comments
                  final commentData = doc.data() as Map<String, dynamic>;
                  print(commentData["CommentText"]);
                  // return the comment
                  return Comment(
                    text: commentData["CommentText"],
                    user: commentData["CommentedBy"], 
                    time: formatDate(commentData["CommentTime"]),
                    );
                }).toList(),
              );
            },
            ),
        ] 
      ),
    );
  }
}