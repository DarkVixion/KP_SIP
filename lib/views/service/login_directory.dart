import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttersip/views/home_page.dart';
import 'package:fluttersip/views/UserView/user_home_page.dart';
import '../AdminView/admin_home_page.dart';



class LoginDirectoy extends StatefulWidget {
  const LoginDirectoy({super.key});

  @override
  State<LoginDirectoy> createState() => _TestLogicState();
}

class _TestLogicState extends State<LoginDirectoy> {
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
        MaterialPageRoute(builder: (context) => const AdminHomePage()),
      );
    } else if (role == 'user') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const UserHomePage()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
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
