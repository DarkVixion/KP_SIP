import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttersip/FrontEndOnly/Service/global_service_fe.dart';
import 'package:fluttersip/FrontEndOnly/profile_page_fe.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:provider/provider.dart';


class AdminHomePageFE extends StatefulWidget {
  const AdminHomePageFE({super.key});

  @override
  State<AdminHomePageFE> createState() => _AdminHomePageFEState();
}

class _AdminHomePageFEState extends State<AdminHomePageFE> {

  final User user = FirebaseAuth.instance.currentUser!;
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

  @override
  Widget build(BuildContext context) {
    final globalState = Provider.of<GlobalStateFE>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard FE'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              FirebaseAuth.instance.signOut();
              Navigator.pop(context);
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
                    // SizedBox(width: 0),
                    // Text('test'),
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // User Details
              const SizedBox(height: 16),
              Text(
                globalState.userService.userName ?? "Loading...",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                globalState.userService.userRole ?? "Loading...",
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              const Text(
                'Peka Saya',
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
                        cornerRadius: 20.0,
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
                      icon: const Icon(Icons.layers),
                      count: totalPekaCount,
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: _PekaCard(
                      title: 'Open',
                      icon: Icon(Icons.folder_open),
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
                      icon: Icon(Icons.checklist),
                      count: 8,
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: _PekaCard(
                      title: 'Waiting Approval',
                      icon: Icon(Icons.access_time),
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
                      title: 'Rejected',
                      icon: Icon(Icons.cancel),
                      count: 0,
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: _PekaCard(
                      title: 'Overdue',
                      icon: Icon(Icons.calendar_today),
                      count: 0,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Super Admin Section
              const Row(
                children: [
                  Text(
                    'Super Admin',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Column(
                    children: [
                      ToggleSwitch(
                        customWidths: const [100.0, 100.0],
                        cornerRadius: 20.0,
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






            ],
          ),
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


class _PekaCard extends StatelessWidget {
  final String title;
  final Icon icon;
  final int count;

  const _PekaCard({required this.title, required this.icon, required this.count});

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
