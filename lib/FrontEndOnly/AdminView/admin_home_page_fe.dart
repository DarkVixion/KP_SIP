
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttersip/FrontEndOnly/AdminView/admin_peka_page_fe.dart';

import 'package:fluttersip/FrontEndOnly/Service/global_service_fe.dart';
import 'package:fluttersip/FrontEndOnly/profile_page_fe.dart';
import 'package:fluttersip/constants/constants.dart';
import 'package:get/get.dart';

import 'package:get_storage/get_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:provider/provider.dart';


class AdminHomePageFE extends StatefulWidget {
  const AdminHomePageFE({super.key});

  @override
  State<AdminHomePageFE> createState() => _AdminHomePageFEState();
}

class _AdminHomePageFEState extends State<AdminHomePageFE> {

  @override
  void initState() {
    super.initState();

    fetchStatusCounts();
  }


  int totalPekaCount = 0;
  int totalOpenCount = 0;
  int totalClosedCount = 0;
  int totalOnProcessCount = 0;
  int totalRejectedCount = 0;
  int totalOverdueCount = 0;

  Future<void> fetchStatusCounts() async {
    Dio dio = Dio();
    try {
      final response = await dio.get('${url}tindaklanjuts');
      if (response.statusCode == 202) {
        List tindaklanjuts = response.data;

        // Filter the data based on status and count
        setState(() {
          totalPekaCount = tindaklanjuts.length;
          totalOpenCount = tindaklanjuts.where((tindaklanjut) => tindaklanjut['status'] == 'Open').length;
          totalClosedCount = tindaklanjuts.where((tindaklanjut) => tindaklanjut['status'] == 'Closed').length;
          totalOnProcessCount = tindaklanjuts.where((tindaklanjut) => tindaklanjut['status'] == 'OnProcess').length;
          totalRejectedCount = tindaklanjuts.where((tindaklanjut) => tindaklanjut['status'] == 'Rejected').length;
          totalOverdueCount = tindaklanjuts.where((tindaklanjut) => tindaklanjut['status'] == 'Overdue').length;
        });
      }
    } catch (e) {
      print("Error fetching Tindak Lanjut count: $e");
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
    final box = GetStorage();
    var userName = box.read('userName');
    // var userEmail = box.read('userEmail');
    var userRole = box.read('userRole');

    // var userFungsiD = box.read('userFungsiD');
    // var userFungsiJ = box.read('userFungsiJ');
    final globalState = Provider.of<GlobalStateFE>(context);
    return StreamBuilder<Object>(
      stream: null,
      builder: (context, snapshot) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Admin Dashboard FE'),
            actions: [
              IconButton(
                onPressed: () {
                  // Get.offAll(() => const UserFormPage1FE());
                },
                icon: const Icon(Icons.notifications),
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
          body: StreamBuilder<Object>(
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
                        userName,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        userRole,
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
                              onTap: () {
                                Get.offAll(const TindakLanjutPageFE());
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _PekaCard(
                              title: 'Open',
                              icon: const Icon(Icons.folder_open,
                                color: Color.fromARGB(255, 210, 157, 172),),
                              count: totalOpenCount,
                              onTap: (){
                                Get.offAll(TindakLanjutPageFE(statusFilter: 'Open'));
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                       Row(
                        children: [
                          Expanded(
                            child: _PekaCard(
                              title: 'Close',
                              icon: const Icon(Icons.checklist,
                                  color: Color.fromARGB(221, 50, 205, 50)),
                              count: totalClosedCount,
                              onTap: () {
                                Get.offAll(TindakLanjutPageFE(statusFilter: 'Closed'));
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                           Expanded(
                            child: _PekaCard(
                              title: 'On Progress',
                              icon: const Icon(Icons.access_time,
                                  color: Color.fromARGB(255, 192, 15, 12)),
                              count: totalOnProcessCount, onTap: () {
                              Get.offAll(TindakLanjutPageFE(statusFilter: 'OnProcess'));
                            },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                       Row(
                        children: [
                          Expanded(
                            child: _PekaCard(
                              title: 'Rejected',
                              icon: const Icon(Icons.cancel,
                                  color: Color.fromARGB(255, 255, 137, 129)),
                              count: totalRejectedCount, onTap: () {
                              Get.offAll(TindakLanjutPageFE(statusFilter: 'Rejected'));
                            },
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _PekaCard(
                              title: 'Overdue',
                              icon: const Icon(Icons.calendar_today,
                                  color: Color.fromARGB(255, 117, 117, 117)),
                              count: totalOverdueCount, onTap: () {
                              Get.offAll(TindakLanjutPageFE(statusFilter: 'Overdue'));
                            },
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
    );
  }
}


class _PekaCard extends StatelessWidget {
  final String title;
  final Icon icon;
  final int count;
  final VoidCallback onTap;

  const _PekaCard({required this.title, required this.icon, required this.count, required this.onTap,});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
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
      ),
    );
  }
}
