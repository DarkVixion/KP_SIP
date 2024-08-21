import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:provider/provider.dart';
import 'package:fluttersip/FrontEndOnly/Service/global_service_fe.dart';
import 'package:fluttersip/FrontEndOnly/main_page_fe.dart';




class ProfilePageFE extends StatefulWidget {
  const ProfilePageFE({super.key});

  @override
  _MyProfilePageState createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<ProfilePageFE> {
  final user = FirebaseAuth.instance.currentUser!;
  String? _profileImageUrl; // Variable to store profile image URL

  @override
  void initState() {
    super.initState();
    _loadProfileImage();
  }

  Future<void> _loadProfileImage() async {
    try {
      final globalState = Provider.of<GlobalStateFE>(context, listen: false);
      String path;

      // Set image path based on user role
      if (globalState.userService.userRole == 'admin') {
        path = 'adminprofile.jpg'; // Admin image path
      } else {
        path = 'userprofile.jpg'; // User image path
      }

      final ref = FirebaseStorage.instance.ref().child(path);
      final url = await ref.getDownloadURL();
      setState(() {
        _profileImageUrl = url;
      });
    } catch (e) {
      print('Error loading profile image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final globalState = Provider.of<GlobalStateFE>(context);

    return Scaffold(
      body: StreamBuilder<Object>(
        stream: null,
        builder: (context, snapshot) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.blue,
                  backgroundImage: _profileImageUrl != null
                      ? NetworkImage(_profileImageUrl!)
                      : null,
                  child: _profileImageUrl == null
                      ? const Icon(
                    Icons.person,
                    color: Colors.white,
                    size: 50,
                  )
                      : null,
                ),
                const SizedBox(height: 16),
                Text(
                  globalState.userService.userName ?? "Loading...",
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
                                  globalState.userService.userKantor ?? "Loading..." ,
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
                                  child: Text(
                                    globalState.userService.userRole ?? "Loading...",
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
                                  globalState.userService.userEmail ?? "Loading..." ,
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
                Padding(
                  padding: const EdgeInsets.all(8.0),

                  child: Container(
                    child: const Column(
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
                            await FirebaseAuth.instance.signOut();
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => const MainPageFE()),
                            );
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
