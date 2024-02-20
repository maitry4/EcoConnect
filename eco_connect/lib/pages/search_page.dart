import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eco_connect/components/image_post_ui.dart';
import 'package:eco_connect/components/my_textfield.dart';
import 'package:eco_connect/components/post_ui.dart';
import 'package:eco_connect/components/search_post_ui.dart';
import 'package:eco_connect/helper/helper_method.dart';
import 'package:eco_connect/pages/profile_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _searchController = TextEditingController();

  getUsers() async {
    String resUser = _searchController.text;
    if(resUser.isNotEmpty)
    {try {

      CollectionReference userPostsCollection =
          FirebaseFirestore.instance.collection("Users");
      QuerySnapshot<Object?> snapshot = await userPostsCollection.get();
      List<String> docIds = snapshot.docs.map((doc) => doc.id).toList();
      print("****************");
      print(docIds);

      // Loop through the list and check for match
      bool isMatchFound = false;
      for (final email in docIds) {
        if (email.toLowerCase() == _searchController.text.toLowerCase()) {
          isMatchFound = true;
          break; // Stop iterating if a match is found
        }
      }
      // Print the result
      if (isMatchFound) {
        print("exists in the list.");
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProfilePage(username: resUser),
          ),
        );
      } else {
        showDialog(
            context: context,
            builder: (context) {
              return const AlertDialog(title: Text("Couldn't find the user!"));
            });
        print("not found in the list.");
      }
      return docIds;
    } catch (error) {
      showDialog(
            context: context,
            builder: (context) {
              return const AlertDialog(title: Text("Error fetching User!"));
            });
      print("Error fetching document IDs: $error");
      return []; // Return an empty list if an error occurs
    }}
    else{
      showDialog(
            context: context,
            builder: (context) {
              return const AlertDialog(title: Text("Please Enter a User!"));
            });
    }
    setState(() {
    _searchController.clear();
      
    });
  @override
  void dispose() {
    super.dispose();
    _searchController.dispose();
  }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            MyTextField(
                controller: _searchController,
                hintText: "Search specific User(email)",
                obscureText: false),
            Padding(
              padding: const EdgeInsets.only(left: 300.0),
              child: IconButton(
                icon: Icon(Icons.person_search),
                onPressed: getUsers,
              ),
            ),
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("User Image Posts")
                    .orderBy("TimeStamp", descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 4.0,
                          mainAxisSpacing: 4.0),
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        // get message
                        final post = snapshot.data!.docs[index];
                        return SearchPostUi(
                          user: post["UserEmail"],
                          postId: post.id,
                          imageUrl: post['PostImageURL'],
                        );
                      },
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
          ],
        ),
      ),
    );
  }
}
