import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttersip/FrontEndOnly/AdminView/admin_home_page_fe.dart';
import 'package:fluttersip/FrontEndOnly/UserView/user_home_page_fe.dart';
import 'package:fluttersip/FrontEndOnly/home_page_fe.dart';




class LoginDirectoryFE extends StatefulWidget {
  const LoginDirectoryFE({super.key});

  @override
  State<LoginDirectoryFE> createState() => _TestLogicState();
}

class _TestLogicState extends State<LoginDirectoryFE> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<User?> getCurrentUser() async {
    User? user = auth.currentUser;
    return user;
  }


  void navigateBasedOnRole(String role) {
    if (role == 'admin') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const AdminHomePageFE()),
      );
    } else if (role == 'user') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const UserHomePageFE()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePageFE()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<User?>(
        future: getCurrentUser(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData) {
            return const Center(child: Text('No user found'));
          }

          final currentUser = snapshot.data;
          final userEmail = currentUser!.email;

          return StreamBuilder<QuerySnapshot>(
            stream: firestore.collection('users').where('email', isEqualTo: userEmail).snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(child: Text('No matching users found'));
              }

              final documents = snapshot.data!.docs;
              final data = documents.first.data() as Map<String, dynamic>;
              final role = data['role'];

              // Call the navigateBasedOnRole function to navigate to the appropriate page
              WidgetsBinding.instance.addPostFrameCallback((_) {
                navigateBasedOnRole(role);
              });

              return const Center(child: CircularProgressIndicator()); // Placeholder while navigating
            },
          );
        },
      ),
    );
  }
}
