
import 'package:flutter/material.dart';
import 'package:fluttersip/FrontEndOnly/AdminView/admin_home_page_fe.dart';
import 'package:fluttersip/FrontEndOnly/UserView/user_home_page_fe.dart';
import 'package:fluttersip/FrontEndOnly/home_page_fe.dart';
import 'package:fluttersip/FrontEndOnly/login_page_fe.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';



class MainPageFE extends StatelessWidget {
  MainPageFE({super.key});
  final box = GetStorage();
  @override
  Widget build(BuildContext context) {
    // Checking if token exists in GetStorage
    Future.delayed(const Duration(seconds: 2), () {
      String? token = box.read('token');
      if (token != null && token.isNotEmpty) {
        // Get.offAll(() => const ProfilePageFE());
        // If token exists, navigate to HomePage
        var userRole = box.read('userRole');
        // Set default role to 'User' if userRole is null or empty
        if (userRole == null || userRole.isEmpty) {
          userRole = 'User';
        }
        if (userRole == 'Admin') {
          Get.offAll(() => const AdminHomePageFE());
        } else if (userRole == 'User') {
          Get.offAll(() => const UserHomePageFE());
        } else {
          Get.offAll(() => const HomePageFE());
        }
      } else {
        // If no token, navigate to LoginPage
        Get.offAll(() => const LoginPageFE());
      }
    });

    // Show a loading indicator while checking
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

