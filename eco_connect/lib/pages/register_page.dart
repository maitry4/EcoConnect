import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eco_connect/intro_pages/intro_page1.dart';
import 'package:eco_connect/pages/onboarding_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:eco_connect/components/my_button.dart';
import 'package:eco_connect/components/my_textfield.dart';
import 'package:flutter_svg/flutter_svg.dart';

class RegisterPage extends StatefulWidget {
  final Function()? onTap;
  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // text editing controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmpasswordController = TextEditingController();

  // sign user up method
  void signUserUp() async {
    // show loading circle
    showDialog(context: context, builder: (context) {
      return const Center(child: CircularProgressIndicator(),
      );
    });
    // try creating the user
    try {
      // check if password is same as confirm paswword. and both of them are greater than 6 characters
      final passLen = passwordController.text.length;
      if(passwordController.text == confirmpasswordController.text && passLen>=6)
      {   
          // create a user
            UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: emailController.text, 
            password: passwordController.text
          );

          // after that create a new document in cloud firebase called Users
          await FirebaseFirestore.instance
          .collection('Users')
          .doc(userCredential.user!.email)
          .set({
            'username': emailController.text.split('@')[0],
            'bio': 'empty bio',
            'isExpert':false,
            'isIndustry':false,
            'followers':[],
            'following':[],
            'userHasCompletedOnboarding':false,
          });
          Navigator.pop(context);

          Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return OnBoardingPage();
                  }));
          
      }
      else {
        // show error message
        Navigator.pop(context);
        invalidCredential("Password(s) don't match! Or is less than 6 characters");
      }
    } on FirebaseAuthException catch (e) {
      if(e.code=='invalid-credential'){
        invalidCredential(e.code);
        Navigator.pop(context);
        
      }
      else if(e.code=='auth/email-already-in-use'){
        invalidCredential(e.code);
        Navigator.pop(context);
        
      }
      else{
        invalidCredential(e.code);
        Navigator.pop(context);
      }

    }

    // pop the loading circle
  }
  void invalidCredential(error) {
    showDialog(context: context, builder: (context) {
      if(error=='invalid-credential'){
        return const AlertDialog(title: Text("Incorrect Email or Password"));
      }
      else {
        return AlertDialog(title: Text(error));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Center(
          child: ListView(
            children: [
              const SizedBox(height: 25),

              // logo
              SvgPicture.asset(
                'lib/images/main_icon.svg',
                height: 150,
              ),

              const SizedBox(height: 25),

              // Let's create an account for you
              Center(
                child: Text(
                  'Join the community of action takers!',
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

              // confirm password textfield
              MyTextField(
                controller: confirmpasswordController,
                hintText: 'Confirm Password',
                obscureText: true,
              ),

            

              const SizedBox(height: 25),

              // sign in button
              MyButton(
                text: "Sign up",
                onTap: signUserUp,
              ),

              const SizedBox(height: 50),

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

                    Expanded(
                      child: Divider(
                        thickness: 0.5,
                        color: Colors.grey[400],
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 50,),
              // not a member? register now
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Already have an Account?',
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                  const SizedBox(width: 4),
                  GestureDetector(
                    onTap: widget.onTap,
                    child: const Text(
                      'Login now',
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