
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttersip/FrontEndOnly/Service/global_service_fe.dart';
import 'package:fluttersip/FrontEndOnly/profile_page_fe.dart';
import 'package:path_provider/path_provider.dart';
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

  bool isDownloading = false;
  String progress = '';

  Future<void> downloadFile() async {
    Dio dio = Dio();
    try {
      setState(() {
        isDownloading = true;
      });

      // Define the URL and the file path
      String url = "https://elibrary.unikom.ac.id/id/eprint/4886/8/UNIKOM_10113414_NANDA TEMAS MIKO_BAB II.pdf";
      String fileName = url.split('/').last;

      // Get the directory to save the file
      var dir = await getApplicationDocumentsDirectory();

      await dio.download(
        url,
        "${dir.path}/$fileName",
        onReceiveProgress: (received, total) {
          if (total != -1) {
            setState(() {
              progress = "${(received / total * 100).toStringAsFixed(0)}%";
            });
          }
        },
      );

      setState(() {
        isDownloading = false;
        progress = "Download Completed";
      });

      // Display the file path after download
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("File saved to ${dir.path}/$fileName")),
      );
    } catch (e) {
      setState(() {
        isDownloading = false;
        progress = "Download Failed";
      });
      print(e.toString());
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
          // IconButton(
          //   icon: const Icon(Icons.logout),
          //   onPressed: () {
          //     FirebaseAuth.instance.signOut();
          //     Navigator.pop(context);
          //   },
          // ),
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
      body: StreamBuilder<QuerySnapshot>(
        stream: null,
        builder: (context, snapshot) {
          return SingleChildScrollView(
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
                            color: Color.fromARGB(255, 103, 80, 164),),
                          count: totalPekaCount,
                        ),
                      ),
                      const SizedBox(width: 16),
                      const Expanded(
                        child: _PekaCard(
                          title: 'Open',
                          icon: Icon(Icons.folder_open,
                            color: Color.fromARGB(255, 210, 157, 172),),
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
                              color: Color.fromARGB(221, 50, 205, 50)),
                          count: 8,
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: _PekaCard(
                          title: 'On Progress',
                          icon: Icon(Icons.access_time,
                              color: Color.fromARGB(255, 192, 15, 12)),
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
                          icon: Icon(Icons.cancel,
                              color: Color.fromARGB(255, 255, 137, 129)),
                          count: 0,
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: _PekaCard(
                          title: 'Overdue',
                          icon: Icon(Icons.calendar_today,
                              color: Color.fromARGB(255, 117, 117, 117)),
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
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            isDownloading
                                ? const CircularProgressIndicator():
                            Flexible(
                              child: ElevatedButton(
                                onPressed: downloadFile,
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
                                      Icon(Icons.download),
                                      SizedBox(width: 16),
                                      Text('DownLoad Peka'),
                                      Spacer(),
                                      Icon(Icons.keyboard_arrow_down),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(progress),
                          ],
                        ),
                        const SizedBox(height: 8.0),
                      ],
                    ),
                  ),

                ],
              ),
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
