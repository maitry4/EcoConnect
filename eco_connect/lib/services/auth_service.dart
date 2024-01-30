import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService{
  // Google sign in
  signInWithGoogle() async {
    // begin the interactive sign in process (choose your account)
    final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();

    // obtain auth details from the request
    final GoogleSignInAuthentication gAuth = await gUser!.authentication;

    // create a new credential for user
    final credential = GoogleAuthProvider.credential(
      accessToken: gAuth.accessToken,
      idToken: gAuth.idToken,
    );

    // finally, let's sign in
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }
}