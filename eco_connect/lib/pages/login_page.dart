import 'package:eco_connect/pages/forgot_pw_page.dart';
import 'package:eco_connect/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:eco_connect/components/my_button.dart';
import 'package:eco_connect/components/my_textfield.dart';
import 'package:eco_connect/components/square_tile.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoginPage extends StatefulWidget {
  final Function()? onTap;
  const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // text editing controllers
  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  void invalidCredential(BuildContext context) {
    showDialog(context: context, builder: (context) {
      return const AlertDialog(title: Text("Invalid Email or Password"));
    });
  }
  // sign user in method
  void signUserIn() async {
    // show loading circle
    // showDialog(context: context, builder: (context) {
    //   return const Center(child: CircularProgressIndicator(),
    //   );
    // });
    // try sign in
    try {
      final res = await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: emailController.text, 
      password: passwordController.text
      );
      print(res);
    } on FirebaseAuthException catch (e) {
      print(e.code);
      print("****************Incorrect Email or Password");
        invalidCredential(context);
        // Navigator.pop(context);
        
      } on PlatformException {
      // Handle platform-specific exceptions
      print("****************An error occurred. Please check your credentials and try again.");
      invalidCredential(context);
      // Navigator.pop(context);
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Center(
          child: ListView(
            children: [
              const SizedBox(height: 50),

              // logo
              /*const Icon(
                Icons.landscape,
                size: 100,
                color: Color.fromARGB(255, 11, 106, 14),
              ),*/
              // svg
              SvgPicture.asset(
                'lib/images/main_icon.svg',
                height: 150,
              ),

              const SizedBox(height: 50),

              // welcome back, you've been missed!
              Center(
                child: Text(
                  'Welcome back you\'ve been missed!',
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 16,
                  ),
                ),
              ),

              const SizedBox(height: 25),

              // email textfield
              MyTextField(
                controller: emailController,
                hintText: 'Email',
                obscureText: false,
              ),

              const SizedBox(height: 10),

              // password textfield
              MyTextField(
                controller: passwordController,
                hintText: 'Password',
                obscureText: true,
              ),

              const SizedBox(height: 10),

              // forgot password?
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap:() {
                        Navigator.push(context, 
                        MaterialPageRoute(builder: (context){
                          return const ForgotPasswordPage();
                          },
                        ),
                      );
                      },
                      child: Text(
                        'Forgot Password?',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              // sign in button
              MyButton(
                text: "Sign in",
                onTap: signUserIn,
              ),

              const SizedBox(height: 50),

              // or continue with
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Divider(
                        thickness: 0.5,
                        color: Colors.grey[400],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Text(
                        'Or continue with',
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        thickness: 0.5,
                        color: Colors.grey[400],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 50),

              // google + apple sign in buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // google button
                  SquareTile(
                    onTap: () => AuthService().signInWithGoogle(),
                    imagePath: 'lib/images/google.png'
                    ),

                  const SizedBox(width: 25),

                  // apple button
                  // SquareTile(imagePath: 'lib/images/apple.png')
                ],
              ),

              const SizedBox(height: 50),

              // not a member? register now
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Not a member?',
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                  const SizedBox(width: 4),
                  GestureDetector(
                    onTap: widget.onTap,
                    child: const Text(
                      'Register now',
                      style: TextStyle(
                        color: Color(0xFF76DEAD),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}