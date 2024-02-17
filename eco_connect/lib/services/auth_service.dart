import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService{
  // Google sign in
  signInWithGoogle() async {
    // begin the interactive sign in process (choose your account)
    final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();
    if (gUser == null) {
      // Handle sign in cancellation or error
      // print("null");
      return null;
    }
    // obtain auth details from the request
    final GoogleSignInAuthentication gAuth = await gUser.authentication;

    // create a new credential for user
    final credential = GoogleAuthProvider.credential(
      accessToken: gAuth.accessToken,
      idToken: gAuth.idToken,
    );
    // finally, let's sign in
    final UserCredential userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);
    // Access user's email
    final String? email = userCredential.user?.email;
    // print('User Email: $email');

    // try to get existing data
    try {
      final existingDoc =
          await FirebaseFirestore.instance.collection('Users').doc(email).get();

      // If the document already exists, return
      if (existingDoc.exists) {
        return;
      }
    } catch (e) {
      // Handle any potential errors
      print('Error while checking for existing document: $e');
    }

    // after that create a new document in cloud firebase called Users
    await FirebaseFirestore.instance
    .collection('Users')
    .doc(email)
    .set({
      'username': email?.split('@')[0] ?? 'Unknown',
      'bio': 'empty bio',
      'isExpert':false,
      'isIndustry':false,
      'followers':[],
      'following':[],
    });
          
  }
}
