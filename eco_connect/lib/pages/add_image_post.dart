import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';
import 'package:image_picker/image_picker.dart';

import 'package:eco_connect/components/my_textfield.dart';
import 'package:flutter/material.dart';

class AddPostImagePage extends StatefulWidget {
  const AddPostImagePage({super.key});

  @override
  State<AddPostImagePage> createState() => _AddPostImagePageState();
}

class _AddPostImagePageState extends State<AddPostImagePage> {
  final TextEditingController _descriptionController = TextEditingController();
  final currentUser = FirebaseAuth.instance.currentUser!;
  final storageRef = FirebaseStorage.instance.ref().child('Images');

  bool isLoading = false;
  Uint8List? _file;

  // void showingDialogBox(String text) {
  //   showDialog(context: context, builder: (context) {
  //     return const AlertDialog(title: Text(text));
  //   });
  // }

  // for picking up image from gallery
  pickImage(ImageSource source) async {
    final ImagePicker imagePicker = ImagePicker();
    try {
      XFile? file = await imagePicker.pickImage(source: source);
      if (file != null) {
        return await file.readAsBytes();
      } else {
        showDialog(context: context, builder: (context) {
      return const AlertDialog(title: Text('No image selected.'));
    });
        print('No image selected.');
      }
    } catch (e) {
        showDialog(context: context, builder: (context) {
      return const AlertDialog(title: Text('Error picking image'));
    });
      print('Error picking image: $e');
    }
  }

  _selectImage(BuildContext parentContext) async {
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: const Text('Create a Post'),
            children: [
              SimpleDialogOption(
                  padding: const EdgeInsets.all(20),
                  child: const Text("Take a Photo"),
                  onPressed: () async {
                    Navigator.of(context).pop();
                    Uint8List file = await pickImage(ImageSource.camera);
                    setState(() {
                      _file = file;
                    });
                  }),
              SimpleDialogOption(
                  padding: const EdgeInsets.all(20),
                  child: const Text('Choose from Gallery'),
                  onPressed: () async {
                    Navigator.of(context).pop();
                    Uint8List file = await pickImage(ImageSource.gallery);
                    setState(() {
                      _file = file;
                    });
                  }),
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text("Cancel"),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          );
        });
  }

  // post a message
  void postImage() {
    // only post if there is something in the text field
    if (_descriptionController.text.isNotEmpty && _file != null) {
      setState(() {
        isLoading = true;
    });
      // Upload image to Firebase Storage
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('Images'); // Replace with your folder name
      final filename = const Uuid().v4(); // Generate unique filename
      final uploadTask = storageRef.child('$filename.jpg').putData(_file!);
      print("(((((((())))))))");
      final desc = _descriptionController.text;
      print(_descriptionController.text);
      uploadTask.then((taskSnapshot) {
        // Get the download URL of the uploaded image
        taskSnapshot.ref.getDownloadURL().then((downloadURL) {
          // Update Firestore document with the download URL
          FirebaseFirestore.instance.collection("User Image Posts").add({
            'UserEmail': currentUser.email,
            'description': desc,
            'TimeStamp': Timestamp.now(),
            'Likes': [],
            'commentCount': 0,
            'PostImageURL': downloadURL
          });
        });
      }).catchError((error) {
        // Handle upload errors
        showDialog(context: context, builder: (context) {
      return const AlertDialog(title: Text('An Error Occurred'));
    });
        print(error);
      });
    }
    else{
      showDialog(context: context, builder: (context) {
      return const AlertDialog(title: Text('Nothing in Caption or File not uploaded'));
    });
    }
    clearSelectedImage();
    setState(() {
      _descriptionController.clear();
    });
    showDialog(context: context, builder: (context) {
      return const AlertDialog(title: Text('Image Uploaded Successfully!!'));
    });
  }

  @override
  void dispose() {
    super.dispose();
    _descriptionController.dispose();
  }
  void clearSelectedImage() {
  setState(() {
    _file = null;
  });
}

  @override
  Widget build(BuildContext context) {
    return _file == null
        ? Scaffold(
            appBar: AppBar(),
            body: Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 80.0),
                child: Column(
                  children: [
                    const Text("Click or an Upload Image",
                        style: TextStyle(
                          fontSize: 30,
                        )),
                    IconButton(
                      icon: const Icon(
                        Icons.cloud_upload_rounded,
                      ),
                      color: Colors.grey[800],
                      iconSize: 50,
                      onPressed: () => _selectImage(context),
                    ),
                  ],
                ),
              ),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              actions: [
                TextButton(
                    onPressed: postImage,
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Post',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize:20,
                          // color: Colors.white,
                        ),
                      ),
                    ))
              ],
            ),
            body: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      left: 8.0, right: 8.0, top: 18.0, bottom: 8.0),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.person,
                          size: 62,
                          color: Theme.of(context).appBarTheme.backgroundColor,
                        ),
                        SizedBox(
                            width: 200,
                            child: MyTextField(
                              controller: _descriptionController,
                              hintText: "Write a Caption",
                              obscureText: false,
                            )),
                        const Divider(),
                        SizedBox(
                          height: 45.0,
                          width: 45.0,
                          child: AspectRatio(
                            aspectRatio: 487 / 451,
                            child: Container(
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                fit: BoxFit.fill,
                                alignment: FractionalOffset.topCenter,
                                image: MemoryImage(_file!),
                              )),
                            ),
                          ),
                        ),
                      ]),
                )
              ],
            ),
          );
  }
}
