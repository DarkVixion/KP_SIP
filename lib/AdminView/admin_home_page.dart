import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttersip/profile_page.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:provider/provider.dart';
import 'package:fluttersip/service/global_service.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({super.key});

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {

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
    final globalState = Provider.of<GlobalState>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
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
                  MaterialPageRoute(builder: (context) => const ProfilePage()),
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
              const TextField(
                decoration: InputDecoration(
                  labelText: 'Unit Kerja',
                  hintText: 'PT. Patra Drilling Contractor',
                ),
              ),
              const SizedBox(height: 16),

              // Peka Stats Section
              const Text(
                'Total Peka',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'PT. Patra Drilling Contractor',
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 150,
                      width: 150,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          CircularProgressIndicator(
                            value: 0.5, // Replace with actual value
                            strokeWidth: 10,
                            color: Colors.yellow,
                          ),
                          Text(
                            '308',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Total',
                            style: TextStyle(
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              height: 16,
                              width: 16,
                              decoration: BoxDecoration(
                                color: Colors.yellow,
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Text('Close'),
                          ],
                        ),
                        const Text('288'),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              height: 16,
                              width: 16,
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Text('Open'),
                          ],
                        ),
                        const Text('3'),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              height: 16,
                              width: 16,
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Text('Rejected'),
                          ],
                        ),
                        const Text('3'),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              height: 16,
                              width: 16,
                              decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Text('Waiting Approval'),
                          ],
                        ),
                        const Text('14'),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Overdue Section
              const Text(
                'Overdue',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 16),
              const TextField(
                decoration: InputDecoration(
                  hintText: '7',
                ),
              ),
              const SizedBox(height: 32),

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
