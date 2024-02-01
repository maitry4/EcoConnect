import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eco_connect/components/like_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PostUi extends StatefulWidget {
  final String message;
  final String user;
  final String postId;
  final List<String> likes;

  const PostUi({
    super.key, 
    required this.message,
    required this.user,
    required this.postId,
    required this.likes,
    });

  @override
  State<PostUi> createState() => _PostUiState();
}

class _PostUiState extends State<PostUi> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  bool isLiked = false;

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

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color:Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      margin:EdgeInsets.only(top: 25, left: 25, right: 25),
      padding: EdgeInsets.all(25),
      child: Row(
        children: [

          // like count
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

          SizedBox(width: 10),
          // messages and user email
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.user,
               style:TextStyle(color: Colors.grey[500])),
              const SizedBox(height: 10,),
              Text(widget.message),
          ],)
        ] 
      ),
    );
  }
}