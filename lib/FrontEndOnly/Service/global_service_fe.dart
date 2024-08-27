import 'package:flutter/material.dart';
import 'package:fluttersip/FrontEndOnly/AdminView/admin_home_page_fe.dart';
import 'package:fluttersip/FrontEndOnly/AdminView/admin_peka_page_fe.dart';
import 'package:fluttersip/FrontEndOnly/Service/user_service_fe.dart';
import 'package:fluttersip/FrontEndOnly/UserView/user_home_page_fe.dart';
import 'package:fluttersip/FrontEndOnly/UserView/user_peka_page_fe.dart';
import 'package:fluttersip/FrontEndOnly/profile_page_fe.dart';
import 'package:get_storage/get_storage.dart';



class GlobalStateFE with ChangeNotifier {
  static final GlobalStateFE _instance = GlobalStateFE._internal();

  factory GlobalStateFE() => _instance;

  GlobalStateFE._internal();

  final UserServiceFE userService = UserServiceFE();
  int _selectedIndex = 0;
  int get selectedIndex => _selectedIndex;

  Future<void> initialize() async {
    await userService.initialize();
    notifyListeners();
  }

  void onItemTapped(int index, BuildContext context) {
    _selectedIndex = index;
    notifyListeners();
    final box = GetStorage();

    var userRole = box.read('userRole');

    if (index == 0) {
      if (userRole == 'Admin') {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AdminHomePageFE()),
        );
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const UserHomePageFE()),
        );
      }
    } else if (index == 1) {
      if (userRole == 'Admin') {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AdminPekaPageFE()),
        );
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const UserPekaPageFE()),
        );
      }
    } else if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ProfilePageFE()),
      );
    }
  }
}
