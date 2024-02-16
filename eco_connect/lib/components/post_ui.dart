import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eco_connect/components/comment.dart';
import 'package:eco_connect/components/comment_button.dart';
import 'package:eco_connect/components/delete_button.dart';
import 'package:eco_connect/components/like_button.dart';
import 'package:eco_connect/helper/helper_method.dart';
import 'package:eco_connect/pages/profile_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PostUi extends StatefulWidget {
  final String message;
  final String user;
  final String postId;
  final String time;
  final List<String> likes;
  int commentCount;

  PostUi({
    super.key,
    required this.message,
    required this.user,
    required this.postId,
    required this.time,
    required this.likes,
    required this.commentCount,
  });

  @override
  State<PostUi> createState() => _PostUiState();
}

class _PostUiState extends State<PostUi> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  bool isLiked = false;
  // local count of the comments

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
    DocumentReference postRef =
        FirebaseFirestore.instance.collection('User Posts').doc(widget.postId);

    if (isLiked) {
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
    FirebaseFirestore.instance
        .collection("User Posts")
        .doc(widget.postId)
        .collection("Comments")
        .add({
      "CommentText": commentText,
      "CommentedBy": currentUser.email,
      "CommentTime": Timestamp.now(), //format this later
    });
    // update the comment count
    int new_count = widget.commentCount + 1;
    FirebaseFirestore.instance
        .collection("User Posts")
        .doc(widget.postId)
        .update({'commentCount': new_count});

    setState(() {
      widget.commentCount = new_count;
    });
  }

  // show dialog box for adding a comment
  void showCommentDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
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
              child: Text("Cancel", style:TextStyle(color:Colors.black))),
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
              child: Text("Post", style:TextStyle(color:Colors.black))),
        ],
      ),
    );
  }

  void deletePost() {
    // show a dialog box to ask for confirmation
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              backgroundColor: Colors.white,
              title: const Text("Delete Post"),
              content: const Text("Are you sure you want to delete?"),
              actions: [
                // CANCEL
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text("Cancel", style:TextStyle(color:Colors.black))),

                // DELETE
                TextButton(
                    onPressed: () async {
                      // delete the comments
                      final commentDoc = await FirebaseFirestore.instance
                          .collection("User Posts")
                          .doc(widget.postId)
                          .collection("Comments")
                          .get();

                      for (var doc in commentDoc.docs) {
                        await FirebaseFirestore.instance
                            .collection("User Posts")
                            .doc(widget.postId)
                            .collection("Comments")
                            .doc(doc.id)
                            .delete();
                      }

                      // delete the post
                      FirebaseFirestore.instance
                          .collection("User Posts")
                          .doc(widget.postId)
                          .delete()
                          .then((value) => print("post deleted"))
                          .catchError((error) => print("Failed to delete"));

                      // dismis the dialog
                      Navigator.pop(context);
                    },
                    child: Text("Delete", style:TextStyle(color:Colors.black))),
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          width: 2,
          color: const Color(0xFF76DEAD),
        ),
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      margin: EdgeInsets.only(top: 25, left: 25, right: 25),
      padding: EdgeInsets.all(25),
      // post ui
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // group of text {message + user details}
            // messages and user email
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // message
                SizedBox(
                  width: 300,
                  child: Text(
                    widget.message,
                    maxLines: 20, 
                    overflow: TextOverflow.clip,
                  ),
                ),
                
                const SizedBox(
                  height: 5,
                ),
                // user
                GestureDetector(
                  onTap: () {
                    // Check if the post belongs to the current user
                    if (widget.user == currentUser.email) {
                      // Navigate to the current user's profile
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ProfilePage(username: currentUser.email),
                        ),
                      );
                    } else {
                      // Navigate to the other user's profile
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ProfilePage(username: widget.user),
                        ),
                      );
                    }
                  },
                  child: Row(
                    children: [
                      Text(
                        widget.user,
                        style: TextStyle(color: Colors.grey[400]),
                      ),
                      Text(
                        ' . ',
                        style: TextStyle(color: Colors.grey[400]),
                      ),
                      Text(
                        widget.time,
                        style: TextStyle(color: Colors.grey[400]),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // SizedBox(width: 3,),

            // delete button
          ],
        ),

        const SizedBox(
          height: 20,
        ),

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
                Text(
                  widget.commentCount.toString(),
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
            if (widget.user == currentUser.email)
            Column(
              children: [
                DeleteButton(
                  onTap: deletePost,
                ),
                const SizedBox(height: 27),
                // Text("0", style: TextStyle(color:Theme.of(context).scaffoldBackgroundColor)),
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
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return ListView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: snapshot.data!.docs.map((doc) {
                // get the comments
                final commentData = doc.data() as Map<String, dynamic>;
                // print(commentData["CommentText"]);
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
      ]),
    );
  }
}
