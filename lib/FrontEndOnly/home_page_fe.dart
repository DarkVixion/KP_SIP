import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePageFE extends StatefulWidget {
  const HomePageFE({super.key});

  @override
  State<HomePageFE> createState() => _HomePageStateFE();
}

class _HomePageStateFE extends State<HomePageFE> {
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
