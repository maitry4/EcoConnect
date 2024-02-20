import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eco_connect/components/my_textfield.dart';
import 'package:eco_connect/components/post_ui.dart';
import 'package:eco_connect/helper/helper_method.dart';
import 'package:eco_connect/pages/add_image_post.dart';
import 'package:eco_connect/pages/home_images.dart';
import 'package:eco_connect/pages/profile_page.dart';
import 'package:eco_connect/pages/search_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final currentUser = FirebaseAuth.instance.currentUser!;

  final textController = TextEditingController();

  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  // post a message
  void postMessage() {
    // only post if there is something in the text field
    if(textController.text.isNotEmpty) {
      FirebaseFirestore.instance.collection("User Posts").add({
        'UserEmail': currentUser.email,
        'Message': textController.text,
        'TimeStamp': Timestamp.now(),
        'Likes':[],
        'commentCount':0,
      });
    }

    // clear the text field
    setState(() {
      textController.clear();
    });
  }
  // open home page
  // void goToHomePage() {
  //   // pop the menu drawer
  //   Navigator.pop(context);

  //   // go to the home page
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(builder: (context) => HomePage(),
  //     ),
  //   );
  // }
  // open profile page
  // void goToProfilePage() {
  //   // pop the menu drawer
  //   Navigator.pop(context);

  //   // go to the profile page
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(builder: (context) => ProfilePage(username: FirebaseAuth.instance.currentUser != null ? FirebaseAuth.instance.currentUser!.email : 'something'),
  //     ),
  //   );
  // }

  int currentIndex = 0;
  void goToPage(index) {
    setState(() {
      currentIndex = index;
    });
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => _pages[index],
      ),
    );
  }
  final username = FirebaseAuth.instance.currentUser != null ? FirebaseAuth.instance.currentUser!.email : 'something';
  final List _pages = [
    // home page
    const HomePage(),
    // images display
    HomeImagePage(),
    // Add image post page
    AddPostImagePage(),
    // search page
    SearchPage(),
    // profile 2
    ProfilePage(username: FirebaseAuth.instance.currentUser != null ? FirebaseAuth.instance.currentUser!.email : 'something'),
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        actions: [IconButton(onPressed: signUserOut, icon: const Icon(Icons.logout))],
          ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal:15.0, vertical:20.0),
        child: GNav(
          backgroundColor: Colors.white,
            gap: 8,
                color:  const Color(0xFF76DEAD),
                activeColor: Colors.white,
                tabBackgroundColor: const Color(0xFF76DEAD),
                padding:const EdgeInsets.all(8),
                onTabChange: (index) => goToPage(index),
                tabs:const [
                  GButton(
                    icon: Icons.home,
                    text:"Home",
                  ),
                  GButton(
                    icon: Icons.photo_camera_back,
                    text: "Images",
                  ),
                  GButton(
                    icon: Icons.add_a_photo,
                    text:"Post",
                  ),
                  GButton(
                    icon: Icons.search,
                    text:"Search",
                  ),
                  GButton(
                    icon: Icons.person,
                    text:"Profile",
                  ),            
                  
                ]
          ),
      ),
      // drawer: MyDrawer(
      //   onProfileTap: goToProfilePage,
      //   onSignOut: signUserOut,
      // ),
      body: Center(
        child: Column(
          children: [
            
            

            // eco connect
            Expanded(
              child: StreamBuilder(
                stream:FirebaseFirestore.instance
                .collection("User Posts")
                .orderBy(
                  "TimeStamp",
                  descending: true)
                .snapshots(),
                builder: (context, snapshot) {
                  if(snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                      // get message
                      final post = snapshot.data!.docs[index];
                      return PostUi(
                        message: post["Message"], 
                        user: post["UserEmail"],
                        postId: post.id,
                        time: formatDate(post['TimeStamp']),
                        likes:List<String>.from(post['Likes'] ?? []),
                        commentCount: post['commentCount'],
                        );
                    },
                   );
                  }
                  else if(snapshot.hasError) {
                    return Center(child: Text('Error${snapshot.error}'));
                  }
                  return const Center(child: CircularProgressIndicator(),);
                },
                ),
              ),
            
            // post message
            Padding(
              padding: const EdgeInsets.only(top:25.0,left:25.0, right:25.0),
              child: Row(
                children: [
                  Expanded(
                    // text field
                    child: MyTextField(
                      controller: textController,
                      hintText: 'Inspire People with What\'s on Your Mind...',
                      obscureText: false,
                    ),
                  ),
              
                  // post message button
                  IconButton(onPressed: postMessage,
                  icon: Icon(Icons.rocket, color:Theme.of(context).appBarTheme.backgroundColor, size: 35,))
                ]
              ),
            ),
            
            // // logged in as
            // Text("Logged In as: "+currentUser.email!, style: TextStyle(color: Colors.grey),),

            const SizedBox(height: 20,),
          ],
        ),
      )
    );
  }
}