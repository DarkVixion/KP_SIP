import 'package:flutter/material.dart';
import 'package:fluttersip/controllers/authentication.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'package:provider/provider.dart';
import 'package:fluttersip/FrontEndOnly/Service/global_service_fe.dart';




class ProfilePageFE extends StatefulWidget {
  const ProfilePageFE({super.key});

  @override
  _MyProfilePageState createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<ProfilePageFE> {


  @override
  Widget build(BuildContext context) {
    final globalState = Provider.of<GlobalStateFE>(context);
    final AuthenticationController _authenticationController = Get.put(AuthenticationController());
    Get.find<AuthenticationController>();
    final box = GetStorage();
    var userName = box.read('userName');
    var userEmail = box.read('userEmail');
    var userRole = box.read('userRole');
    var userFungsi = box.read('userFungsi');


    return Scaffold(
      body: StreamBuilder<Object>(
        stream: null,
        builder: (context, snapshot) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.blue,
                ),
                const SizedBox(height: 16),
                 Text(
                  '$userName',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    // Handle Edit button press
                  },
                  child: const Text('Edit', style: TextStyle(color: Colors.red)),
                ),

                const SizedBox(height: 32),
                // Unit Kerja
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],

                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Column(
                          children: [
                            Row(mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  '$userFungsi' ,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  padding: const EdgeInsets.only(
                                      left: 16,right: 16, top: 5,bottom: 5),
                                  decoration: const BoxDecoration(
                                    color: Colors.red,
                                  ),
                                  child:  Text(
                                    '$userRole',
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                             Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  '$userEmail' ,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),

                          ],
                        ),
                        const SizedBox(height: 16),

                      ],
                    ),
                  ),
                ),
                // Account
                const Padding(
                  padding: EdgeInsets.all(8.0),

                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text('Account',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        ElevatedButton(
                          onPressed: () {},
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
                                Icon(Icons.lock),
                                SizedBox(width: 16),
                                Text('Change Password'),
                                Spacer(),
                                Icon(Icons.arrow_forward_ios),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () {},
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
                                Icon(Icons.notifications),
                                SizedBox(width: 16),
                                Text('Notification'),
                                Spacer(),
                                Icon(Icons.arrow_forward_ios),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

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
                ),
                const SizedBox(height: 32),

              ],
            ),
          );
        }
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.folder),
            label: 'PEKA',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: globalState.selectedIndex,
        onTap: (index) {
          globalState.onItemTapped(index, context);
        },
      ),
    );
  }
}
