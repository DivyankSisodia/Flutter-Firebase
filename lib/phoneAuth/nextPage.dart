import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class PhoneHome extends StatefulWidget {
  const PhoneHome({super.key});

  @override
  State<PhoneHome> createState() => _PhoneHomeState();
}

class _PhoneHomeState extends State<PhoneHome> {
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();

  void saveUser() {
    String namecontroller = name.text.trim();
    String emailcontroller = email.text.trim();

    name.clear();
    email.clear();

    if (namecontroller != null && emailcontroller != null) {
      Map<String, dynamic> userData = {
        'name': namecontroller,
        'email': emailcontroller,
      };
      FirebaseFirestore.instance.collection('users').add(userData);
      debugPrint('User added successfully!');
    } else {
      debugPrint('Please enter the details!');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(32.0),
            child: TextFormField(
              controller: name,
              decoration: const InputDecoration(
                hintText: 'Enter your name',
              ),
            ),
          ),
          const SizedBox(
            height: 30,
          ),
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
            height: 30,
          ),
          StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection("users").snapshots(),
                builder: (context, snapshot) {

                  if(snapshot.connectionState == ConnectionState.active) {
                    if(snapshot.hasData && snapshot.data != null) {
                      return Expanded(
                        child: ListView.builder(
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {

                            Map<String, dynamic> userMap = snapshot.data!.docs[index].data() as Map<String, dynamic>;

                            return ListTile(
                              title: Text(userMap['name']),
                              subtitle: Text(userMap['email']),
                              trailing: IconButton(icon: Icon(Icons.delete), onPressed: () {
                                FirebaseFirestore.instance.collection("users").doc(snapshot.data!.docs[index].id).delete();
                              }),
                            );
                          },
                        ),
                      );
                    }
                    else {
                      return const Text("No data!");
                    }
                  }
                  else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                }
          )
        ],
      ),
    );
  }
}
