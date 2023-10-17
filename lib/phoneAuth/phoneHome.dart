import 'package:firebaseproject/phoneAuth/nextPage.dart';
import 'package:flutter/material.dart';

class HomePhone extends StatefulWidget {
  const HomePhone({super.key});

  @override
  State<HomePhone> createState() => _HomePhoneState();
}

class _HomePhoneState extends State<HomePhone> {
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
              decoration: const InputDecoration(
                hintText: 'Enter your phone number',
              ),
            ),
          ),
          FloatingActionButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const PhoneHome()));
              },
              child: const Icon(Icons.send)),
        ],
      ),
    );
  }
}
