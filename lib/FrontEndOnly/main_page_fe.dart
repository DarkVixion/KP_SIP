import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttersip/FrontEndOnly/Service/login_directory_fe.dart';
import 'package:fluttersip/FrontEndOnly/login_page_fe.dart';


class MainPageFE extends StatelessWidget {
  const MainPageFE({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot){
          if(snapshot.hasData){
            return const LoginDirectoryFE();
          }else {
            return const LoginPageFE();
          }
        },
      ),
    );
  }
}