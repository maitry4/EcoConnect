import 'package:eco_connect/pages/profile_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SearchPostUi extends StatefulWidget {
  final String user;
  final String postId;
  String? imageUrl;

  SearchPostUi({
    super.key,
    required this.user,
    required this.postId,
    required this.imageUrl,
  });

  @override
  State<SearchPostUi> createState() => _SearchPostUiState();
}

class _SearchPostUiState extends State<SearchPostUi> {
  final currentUser = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    return 
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
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container( // Ensure image doesn't overflow
              child: widget.imageUrl != null
                  ? Image.network(
                      widget.imageUrl!,
                      fit: BoxFit.cover,
                      height: 80, // Adjust height as needed
                    )
                  : const Text("Error loading image! Or no Image"), // Placeholder if no image
                              ),
            ),
          );
    
  }
}
