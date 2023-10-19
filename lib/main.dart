import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebaseproject/email/home.dart';
import 'package:firebaseproject/phoneAuth/phoneHome.dart';
import 'package:firebaseproject/services/notification_services.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await NotificationService.initialize();

  // .get kroge toh querysnap milta h
  QuerySnapshot snapshot =
      await FirebaseFirestore.instance.collection('users').get();
  for (var doc in snapshot.docs) {
    print(doc.data().toString());
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      color: Colors.amberAccent,
      // theme: ThemeData(
      //   primarySwatch: Colors.lime,
      // ),
      home: HomePhone(),
    );
  }
}
