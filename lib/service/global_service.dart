import 'package:flutter/material.dart';
import 'package:fluttersip/AdminView/admin_home_page.dart';
import 'package:fluttersip/AdminView/admin_peka_page.dart';
import 'package:fluttersip/UserView/user_home_page.dart';
import 'package:fluttersip/UserView/user_peka_page.dart';
import 'package:fluttersip/profile_page.dart';
import 'user_service.dart'; // Import your UserService class

class GlobalState with ChangeNotifier {
  static final GlobalState _instance = GlobalState._internal();

  factory GlobalState() => _instance;

  GlobalState._internal();

  final UserService userService = UserService();
  int _selectedIndex = 0;
  int get selectedIndex => _selectedIndex;

  Future<void> initialize() async {
    await userService.initialize();
    notifyListeners();
  }

  void onItemTapped(int index, BuildContext context) {
    _selectedIndex = index;
    notifyListeners();

    if (index == 0) {
      if (userService.userRole == 'admin') {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AdminHomePage()),
        );
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const UserHomePage()),
        );
      }
    } else if (index == 1) {
      if (userService.userRole == 'admin') {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AdminPekaPage()),
        );
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const UserPekaPage()),
        );
      }
    } else if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ProfilePage()),
      );
    }
  }
}
