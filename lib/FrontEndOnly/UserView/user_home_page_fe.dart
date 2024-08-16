import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttersip/FrontEndOnly/Service/image_file_service.dart';
import 'package:fluttersip/FrontEndOnly/Service/user_service_fe.dart';
import 'package:fluttersip/FrontEndOnly/UserView/user_peka_page_fe.dart';
import 'package:fluttersip/FrontEndOnly/profile_page_fe.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:firebase_auth/firebase_auth.dart';


class UserHomePageFE extends StatefulWidget {
  const UserHomePageFE({super.key});

  @override
  State<UserHomePageFE> createState() => _UserHomePageFEState();
}

class _UserHomePageFEState extends State<UserHomePageFE> {
  final User user = FirebaseAuth.instance.currentUser!;
  final userService = UserServiceFE();
  int _selectedIndex = 0;
  final String? userId = FirebaseAuth.instance.currentUser?.uid;
  int totalPekaCount = 0;

  @override
  void initState() {
    super.initState();
    _fetchPekaCount();
  }

  Future<void> _fetchPekaCount() async {
    try {
      // Fetch all documents in the 'observations' collection
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('observations')
          .where('userId', isEqualTo: userId)
          .get();

      // Count the number of documents
      int count = querySnapshot.docs.length;

      setState(() {
        totalPekaCount = count;
      });
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const UserPekaPageFE()),
      );
    } else if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ProfilePageFE()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Test()),
              );
            },
          ),
        ],
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Padding(
                padding: EdgeInsets.symmetric(),
                child: Row(
                  children: <Widget>[
                    Icon(Icons.person),
                  ],
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ProfilePageFE()),
                );
              },
            );
          },
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: null,
        builder: (context, snapshot) {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        userService.userName ?? "Loading...",
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        userService.userRole ?? "Loading...",
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Peka Saya FE',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Column(
                            children: [
                              ToggleSwitch(
                                customWidths: const [100.0, 100.0],
                                cornerRadius: 0,
                                activeBgColors: const [
                                  [Colors.redAccent],
                                  [Colors.redAccent]
                                ],
                                activeFgColor: Colors.white,
                                inactiveBgColor: Colors.grey,
                                inactiveFgColor: Colors.white,
                                totalSwitches: 2,
                                labels: const ['Bulan Ini', 'Minggu Ini'],
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: _PekaCard(
                              title: 'Total PEKA',
                              icon: const Icon(Icons.layers,
                                  color: Color.fromARGB(255, 236, 34, 31)),
                              count: totalPekaCount,
                            ),
                          ),
                          const SizedBox(width: 16),
                          const Expanded(
                            child: _PekaCard(
                              title: 'On Progress',
                              icon: Icon(Icons.access_time,
                                  color: Color.fromARGB(255, 20, 174, 92)),
                              count: 0,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const Row(
                        children: [
                          Expanded(
                            child: _PekaCard(
                              title: 'Close',
                              icon: Icon(Icons.checklist,
                                  color: Color.fromARGB(255, 255, 235, 19)),
                              count: 0,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
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
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}

class _PekaCard extends StatelessWidget {
  final String title;
  final Icon icon;
  final int count;

  const _PekaCard(
      {required this.title, required this.icon, required this.count});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                icon,
                const SizedBox(width: 16),
                Text(
                  '$count',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
