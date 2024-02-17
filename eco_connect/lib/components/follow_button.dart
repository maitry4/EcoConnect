import 'package:flutter/material.dart';

class FollowButton extends StatelessWidget {
  final String text;
  void Function()? onTap;
  
  FollowButton({
    super.key, 
    required this.onTap,
    required this.text});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(24),
        margin: const EdgeInsets.symmetric(horizontal: 25),
        decoration: BoxDecoration(
          color: const Color(0xFF76DEAD),
          borderRadius: BorderRadius.circular(18),
          boxShadow: [  // Added box shadow
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),  // Set shadow color
            spreadRadius: 2,  // Set shadow spread radius
            blurRadius: 4,  // Set shadow blur radius
            offset: const Offset(0, 4),  // Set shadow offset
          ),
          ],
        ),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}