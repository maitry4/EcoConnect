import 'package:cloud_firestore/cloud_firestore.dart';

// Future<bool> isFollowValue() async {
//   String uemail = FirebaseAuth.instance.currentUser!.email;
//   String followId = widget.username;
//     DocumentSnapshot snap =
//         await FirebaseFirestore.instance.collection('Users').doc(uemail).get();
//     List following = (snap.data()! as dynamic)['following'];

//     if (following.contains(followId)) {
//       return true;
//   }
//   else {
//     return false;
//   }