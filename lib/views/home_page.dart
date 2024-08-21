import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final User = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Berhasil Login Sebagai ${User.email!}'),
            MaterialButton(onPressed: () {
              FirebaseAuth.instance.signOut();
              Navigator.pop(context);
            },
            color: Colors.grey,
            child: const Text('Keluar'),
            )
          ],
        ),
      ),
    );
  }
}
