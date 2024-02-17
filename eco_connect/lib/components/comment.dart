import 'package:eco_connect/pages/profile_page.dart';
import 'package:flutter/material.dart';

class Comment extends StatelessWidget {
  final String text;
  final String user;
  final String time;

  const Comment({
    super.key,
    required this.text,
    required this.user,
    required this.time,
    });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        // color: Colors.black[1,
        border: Border.all(
          width: 1,
          color: const Color(0xFF76DEAD),
        ),
        borderRadius: BorderRadius.circular(4),
      ),
      margin: const EdgeInsets.only(bottom: 5),
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // comment
          Text(text),

          const SizedBox(height: 5,),

          GestureDetector(
            onTap:(){
              // Navigate to the current user's profile
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ProfilePage(username: user),
                        ),
                      );
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(user,
                  style: TextStyle(color: Colors.grey[400]),
                  overflow: TextOverflow.clip,
                  ),
                // user, time
                Text(time,
                  style: TextStyle(color: Colors.grey[400]),
                  overflow: TextOverflow.clip,
                  ),
              ],
            ),
          ),

        ],
      ),
    );
  }
}