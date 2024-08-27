import 'package:fluttersip/controllers/authentication.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get_storage/get_storage.dart';

class HomePageFE extends StatefulWidget {
  const HomePageFE({super.key});

  @override
  State<HomePageFE> createState() => _HomePageStateFE();
}

class _HomePageStateFE extends State<HomePageFE> {
  final AuthenticationController _authenticationController = Get.put(AuthenticationController());


  @override
  Widget build(BuildContext context) {
    final box = GetStorage();
    var token = box.read('token');
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('$token'),
            ElevatedButton(
              onPressed: () async {
                await _authenticationController.logout();
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.zero,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero, // Square shape
                ),
              ),
              child: Container(
                width: double.infinity, // Full width
                padding: const EdgeInsets.all(16), // Inner padding
                child: const Row(
                  children: [
                    Icon(Icons.logout),
                    SizedBox(width: 16),
                    Text('Log Out'),
                    Spacer(),
                    Icon(Icons.arrow_forward_ios),
                  ],
                ),
              ),
            ),
          ],
        ),

      ),

    );
  }
}
