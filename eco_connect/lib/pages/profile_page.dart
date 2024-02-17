import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eco_connect/components/follow_button.dart';
import 'package:eco_connect/components/my_button.dart';
import 'package:eco_connect/components/post_ui.dart';
import 'package:eco_connect/helper/helper_method.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfilePage extends StatefulWidget {
  final String? username;
  const ProfilePage({super.key, required this.username});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  final usersCollection = FirebaseFirestore.instance.collection("Users");
  late bool isFollowing;
  late bool isexp;
  late bool isind;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getFollowValue();
  }
  void getFollowValue() async {
    setState(() {
      isLoading = true;
    });
  String? uemail = FirebaseAuth.instance.currentUser!.email;
    String? followId = widget.username;
    DocumentSnapshot snap =
        await FirebaseFirestore.instance.collection('Users').doc(uemail).get();
    List following = (snap.data()! as dynamic)['following'];
    isFollowing = following.contains(followId);
    setState(() {
      isLoading = false;
    });
    print("**********");
    print(isFollowing);
    // getting if the visiting user is expert or industry
    // HERE I WANT TO GET THE VISITING USER'S (CURRENT USER'S ISEXPERT AND ISINDUSTRY VALUE)
    // HERE'S HOW I GET THE CURRENT USER VALUE:
    // CURRENT_USER_EMAIL = FirebaseAuth.instance.currentUser!.email
    DocumentSnapshot<Map<String, dynamic>> snapexp = await FirebaseFirestore.instance
          .collection('Users')
          .doc(FirebaseAuth.instance.currentUser!.email)
          .get();
    bool temp = await (snapexp.data()! as dynamic)['isExpert'];
    bool temp2 = await (snapexp.data()! as dynamic)['isIndustry'];
    setState(()  {
      isexp =  temp;
    });
    setState(()  {
      isind =  temp2;
    });
    print(isexp);


  }


  Future<void> editField(String field) async {
    String newValue = '';
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: Text(
          "Edit $field",
          style: const TextStyle(
            color: Colors.black,
          ),
        ),
        content: TextField(
          autofocus: true,
          style: const TextStyle(
            color: Colors.black,
          ),
          decoration: InputDecoration(
            hintText: "Enter new $field",
            hintStyle: const TextStyle(color: Colors.grey),
          ),
          onChanged: (value) {
            newValue = value;
          },
        ),
        actions: [
          TextButton(
            child: const Text(
              "Cancel",
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: const Text(
              "Save",
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            onPressed: () => Navigator.of(context).pop(newValue),
          ),
        ],
      ),
    );

    if (newValue.trim().isNotEmpty) {
      await usersCollection.doc(currentUser.email).update({field: newValue});
    }
  }

  // follow user
  Future<void> followaUser(String? uemail, String? followId) async {
    try {
      // print("********");
      // print(uemail);
      // print(followId);
      DocumentSnapshot snap = await FirebaseFirestore.instance
          .collection('Users')
          .doc(uemail)
          .get();
      List following = (snap.data()! as dynamic)['following'];

      if (following.contains(followId)) {
        await FirebaseFirestore.instance
            .collection('Users')
            .doc(followId)
            .update({
          'followers': FieldValue.arrayRemove([uemail])
        });

        await FirebaseFirestore.instance
            .collection('Users')
            .doc(uemail)
            .update({
          'following': FieldValue.arrayRemove([followId])
        });
        setState(() {
          print(isFollowing);
          print(FirebaseAuth.instance.currentUser!.email);
          print(widget.username);
          print("Setting isFollowing to false");
          isFollowing = false;
        });
      } else {
        await FirebaseFirestore.instance
            .collection('Users')
            .doc(followId)
            .update({
          'followers': FieldValue.arrayUnion([uemail])
        });

        await FirebaseFirestore.instance
            .collection('Users')
            .doc(uemail)
            .update({
          'following': FieldValue.arrayUnion([followId])
        });
        setState(() {
          print(isFollowing);
          print(FirebaseAuth.instance.currentUser!.email);
          print(widget.username);
          print("Setting isFollowing to true");
          isFollowing = true;
        });
      }
    } catch (e) {
      if (kDebugMode) print(e.toString());
    }
  }

  // open url
  Future<void> _launchURL(Uri url) async {
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    } else {
      // print('yes');
      await launchUrl(url);
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        :  Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 15.0),
        child: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('Users')
              .doc(widget.username)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final userData = snapshot.data!.data() as Map<String, dynamic>;
              return ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 40),
                          child: Row(
                            children: [
                              if(!userData['isExpert'] && !userData['isIndustry'])
                              Icon(
                                Icons.person,
                                size: 62,
                                color: Theme.of(context)
                                    .appBarTheme
                                    .backgroundColor,
                              ),
                              if(userData['isIndustry'])
                              Icon(
                                Icons.factory,
                                size: 62,
                                color: Theme.of(context)
                                    .appBarTheme
                                    .backgroundColor,
                              ),
                              if(userData['isExpert'])
                              Icon(
                                Icons.badge,
                                size: 62,
                                color: Theme.of(context)
                                    .appBarTheme
                                    .backgroundColor,
                              ),

                              const SizedBox(width: 20),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    
                                    children: [
                                      // username
                                      Text(
                                        userData['username'],
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      // Icon to edit
                                      if (widget.username == currentUser.email)
                                        IconButton(
                                            onPressed: () =>
                                                editField('username'),
                                            icon: Icon(Icons.edit,
                                                color: Colors.grey[600],
                                                size: 20)),
                                    // SizedBox(width: 5,),
                                    
                                    if(userData['isIndustry'] && isexp)
                                    MyButton(onTap: () => _launchURL(
                                      Uri.parse('https://docs.google.com/forms/d/e/1FAIpQLSfiELSVfDzeAN-LnNo9bIzawnu-GdHBeNwjvrbrKe5kn295EA/viewform?usp=sf_link')
                                    ),
                                    text: 'Apply'),

                                    if(userData['isExpert'] && isind)
                                    MyButton(onTap: () => _launchURL(
                                      Uri.parse('https://docs.google.com/forms/d/e/1FAIpQLSeIUcNbisGIUqUEI2fUlhbZLo3gO2W4cp2RA4b33whUduOxAg/viewform?usp=sf_link')
                                    ), text: 'Hire Me'),
                                    ],
                                  ),
                                  // bio
                                  Row(
                                    children: [
                                      Text(
                                        userData['bio'],
                                      ),
                                      if (widget.username == currentUser.email)
                                        // Icon to edit
                                        IconButton(
                                            onPressed: () => editField('bio'),
                                            icon: Icon(Icons.edit,
                                                color: Colors.grey[600],
                                                size: 20)),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            buildStatColumn(
                                userData['followers'].length, "followers"),
                            buildStatColumn(
                                userData['following'].length, "following"),
                          ],
                        ),
                        const SizedBox(height: 20),
                        if (widget.username == currentUser.email)
                          Padding(
                            padding: const EdgeInsets.only(left: 39.0),
                            child: Row(
                              children: [
                                if(!userData['isExpert'])
                                MyButton(
                                  text: " Expert ",
                                  onTap: () => _launchURL(
                                      Uri.parse('https://docs.google.com/forms/d/e/1FAIpQLSfun3UsJ3bQ2LNOxBYyQ2OhTjcD6ZkaxHY9s0-m5zn9-C91gQ/viewform?usp=sf_link')),
                                ),
                                if(!userData['isIndustry'])
                                MyButton(
                                  text: "Industry",
                                  onTap: () => _launchURL(
                                      Uri.parse('https://docs.google.com/forms/d/e/1FAIpQLSeYBSP5RzRHtDlv8b7S6M7plk9YuztnBW0ST35Yj2Nl78hY6w/viewform?usp=sf_link')),
                                )
                              ],
                            ),
                          )
                        else if (isFollowing)
                          FollowButton(
                            text: "UnFollow",
                            onTap: () async {
                              await followaUser(
                                  FirebaseAuth.instance.currentUser!.email,
                                  widget.username);
                              setState(() {
                                
                                print(widget.username);
                                print(userData['username']);
                                // print(isFollowing);
                                // print(FirebaseAuth.instance.currentUser!.email);
                                // print(widget.username);
                                // print("Setting isFollowing to false");
                                isFollowing=false;
                              });
                            },
                          )
                        else
                          FollowButton(
                            text: "Follow",
                            onTap: () async {
                              await followaUser(
                                  FirebaseAuth.instance.currentUser!.email,
                                  widget.username);
                              setState(() {
                                // print(isFollowing);
                                // print(FirebaseAuth.instance.currentUser!.email);
                                // print(widget.username);
                                // print("Setting isFollowing to true");
                                isFollowing=true;
                              });
                            },
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 50,
                  ),
                  // users posts
                  Padding(
                    padding: const EdgeInsets.only(top: 30.0, left: 30.0),
                    child: Text(
                      'Posts',
                      style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection("User Posts")
                        .where('UserEmail', isEqualTo: widget.username)
                        .orderBy("TimeStamp", descending: false)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            // get message
                            final post = snapshot.data!.docs[index];
                            return PostUi(
                              message: post["Message"],
                              user: post["UserEmail"],
                              postId: post.id,
                              time: formatDate(post['TimeStamp']),
                              likes: List<String>.from(post['Likes'] ?? []),
                              commentCount: post['commentCount'],
                            );
                          },
                        );
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error${snapshot.error}'));
                      }
                      return const Center(child: CircularProgressIndicator());
                    },
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                ],
              );
            } else if (snapshot.hasError) {
              return Center(child: Text('Error${snapshot.error}'));
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }

  Column buildStatColumn(int num, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          num.toString(),
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 4),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w400,
              color: Colors.grey,
            ),
          ),
        ),
      ],
    );
  }
}
