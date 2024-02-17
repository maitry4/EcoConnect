import 'package:eco_connect/components/my_button.dart';
import 'package:eco_connect/components/my_textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final emailController = TextEditingController();
  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }
  Future passwordReset() async {
    try {
      // Check for user existence first
      final list = await FirebaseAuth.instance.fetchSignInMethodsForEmail(emailController.text.trim());

      if (list.isEmpty) {
        // User not found
        showDialog(
          context: context,
          builder: (context) {
            return const AlertDialog(
              content: Text("Email address not found. Please check the email and try again."),
            );
          },
        );
        return; // Exit the function
      }

      // User exists, proceed with password reset
      await FirebaseAuth.instance.sendPasswordResetEmail(email: emailController.text.trim());

      // Wait for the sendPasswordResetEmail operation to complete before showing the dialog
    await showDialog(
        context: context,
        builder: (context) {
          return const AlertDialog(
            content: Text("Password Reset Link Sent. Check Your Mail!!"),
          );
        },
      );
    } on FirebaseAuthException catch (e) {
      print("****************");
      print(e);
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text(e.message.toString()),
          );
        },
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor:const Color.fromARGB(255, 11, 106, 14),foregroundColor: Colors.white,),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(25.0),
            child: Text(
                    "Enter Your Email and We will send you a password reset link",
                    style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 17,
                  ),),
          ),

          // email textfield
            MyTextField(
              controller: emailController,
              hintText: 'Email',
              obscureText: false,
            ),
            
            const SizedBox(height: 25),

            // sign in button
            MyButton(
              text: "Send Reset Mail",
              onTap: passwordReset,
            ),
        ],

      ),
    );
  }
}