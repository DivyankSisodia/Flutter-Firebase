import 'package:flutter/material.dart';

class PhoneHome extends StatefulWidget {
  const PhoneHome({super.key});

  @override
  State<PhoneHome> createState() => _PhoneHomeState();
}

class _PhoneHomeState extends State<PhoneHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center, 
        children: [
          Padding(
            padding:const EdgeInsets.all(32.0),
            child: TextFormField(
              decoration:const InputDecoration(
                hintText: 'Enter your phone number',
              ),
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          Padding(
            padding: const EdgeInsets.all(32.0),
            child: TextFormField(
              decoration: const InputDecoration(
                hintText: 'Enter your phone number',
              ),
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          FloatingActionButton(
            onPressed: () {},
            child: const Icon(Icons.next_plan_sharp),
          ),
        ],
      ),
    );
  }
}