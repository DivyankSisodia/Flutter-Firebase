// ignore_for_file: unused_import, file_names

import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class PhoneHome extends StatefulWidget {
  const PhoneHome({super.key});

  @override
  State<PhoneHome> createState() => _PhoneHomeState();
}

class _PhoneHomeState extends State<PhoneHome> {
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  File? profilepic;

  Future<void> saveUser() async {
    String namecontroller = name.text.trim();
    String emailcontroller = email.text.trim();

    name.clear();
    email.clear();

    if (namecontroller != null &&
        emailcontroller != null &&
        profilepic != null) {
      UploadTask uploadTask = FirebaseStorage.instance
          .ref()
          .child('profilepics')
          .child(Uuid().v1())
          .putFile(profilepic!);

// if you want to view how much % of image is getting upload in real time.

      StreamSubscription taskSubscription =
          uploadTask.snapshotEvents.listen((snapshot) {
        double progress = snapshot.bytesTransferred / snapshot.totalBytes * 100;
        debugPrint(progress.toString());
      });

// taskupload se task launch ho rha h
// lekin u need to do tasksnapshot jb finish hone pr
      TaskSnapshot taskSnaphot = await uploadTask;

      String downloadUrl = await taskSnaphot.ref.getDownloadURL();

      taskSubscription.cancel();

      Map<String, dynamic> userData = {
        'name': namecontroller,
        'email': emailcontroller,
        'profilepic': downloadUrl,
      };
      FirebaseFirestore.instance.collection('users').add(userData);
      debugPrint('User added successfully!');
    } else {
      debugPrint('Please enter the details!');
    }
    setState(() {
      profilepic = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Phone Auth'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            height: 0,
          ),
          CupertinoButton(
            onPressed: () async {
              XFile? selectedimage =
                  await ImagePicker().pickImage(source: ImageSource.gallery);

              File convertedfile = File(selectedimage!.path);

              setState(() {
                profilepic = convertedfile;
              });

              if (selectedimage != null) {
                debugPrint('Image selected!');
              } else {
                debugPrint('No image selected!');
              }
            },
            padding: EdgeInsets.zero,
            child: CircleAvatar(
              backgroundImage:
                  (profilepic != null) ? FileImage(profilepic!) : null,
              backgroundColor: Colors.blueGrey,
              radius: 40,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(32.0),
            child: TextFormField(
              controller: name,
              decoration: const InputDecoration(
                hintText: 'Enter your name',
              ),
            ),
          ),
          // const SizedBox(
          //   height: 30,
          // ),
          Padding(
            padding: const EdgeInsets.all(32.0),
            child: TextFormField(
              controller: email,
              decoration: const InputDecoration(
                hintText: 'Enter your email',
              ),
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          FloatingActionButton(
            onPressed: () {
              saveUser();
            },
            child: const Icon(Icons.next_plan_sharp),
          ),
          const SizedBox(
            height: 100,
          ),
          StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance.collection("users").snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.active) {
                  if (snapshot.hasData && snapshot.data != null) {
                    return Expanded(
                      child: ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          Map<String, dynamic> userMap =
                              snapshot.data!.docs[index].data()
                                  as Map<String, dynamic>;

                          return ListTile(
                            leading: CircleAvatar(
                              backgroundImage:
                                  NetworkImage(userMap['profilepic']),
                            ),
                            title: Text(userMap['name']),
                            subtitle: Text(userMap['email']),
                            trailing: IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () {
                                  FirebaseFirestore.instance
                                      .collection("users")
                                      .doc(snapshot.data!.docs[index].id)
                                      .delete();
                                }),
                          );
                        },
                      ),
                    );
                  } else {
                    return const Text("No data!");
                  }
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              })
        ],
      ),
    );
  }
}
