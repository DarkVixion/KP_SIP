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
      body: Center(
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

            // Account
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey,
                  width: 1,
                ),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Account',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16),
                  ListTile(
                    leading: Icon(Icons.lock),
                    title: Text('Change Password'),
                    trailing: Icon(Icons.arrow_forward_ios),
                  ),
                  SizedBox(height: 8),
                  ListTile(
                    leading: Icon(Icons.notifications),
                    title: Text('Notification'),
                    trailing: Icon(Icons.arrow_forward_ios),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const MainPageFE()),
                );
              },
              child: const Text('Logout'),
            ),
            const SizedBox(height: 16),
          ],
        ),
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
