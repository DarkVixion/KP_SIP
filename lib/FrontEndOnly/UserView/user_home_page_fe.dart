import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttersip/FrontEndOnly/Service/global_service_fe.dart';
import 'package:fluttersip/FrontEndOnly/profile_page_fe.dart';
import 'package:fluttersip/constants/constants.dart';
import 'package:fluttersip/testcode.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';
import 'package:toggle_switch/toggle_switch.dart';


class UserHomePageFE extends StatefulWidget {
  const UserHomePageFE({super.key});

  @override
  State<UserHomePageFE> createState() => _UserHomePageFEState();
}

class _UserHomePageFEState extends State<UserHomePageFE> {
  final box = GetStorage();

  int totalPekaCount = 0;
  int onProgressCount = 0;
  int closedCount = 0;

  @override
  void initState() {
    super.initState();
    var userID = box.read('userID');
    Provider.of<GlobalStateFE>(context, listen: false).updateUserId(userID);
    fetchPekaCount();  // Fetch the laporan count and tindaklanjuts for the logged-in user
  }


  Future<void> fetchPekaCount() async {
    Dio dio = Dio();
    try {
      // Fetch laporans
      final laporansResponse = await dio.get('${url}laporans');
      if (laporansResponse.statusCode == 202) {
        List laporans = laporansResponse.data;  // Assuming the API returns a list of laporans
        var userId = int.parse(box.read('userID'));  // Get the logged-in user's ID

        // Filter laporans by userId
        List userLaporans = laporans.where((laporan) => laporan['user_id'] == userId).toList();
        List<int> laporanIds = userLaporans.map<int>((laporan) => laporan['id'] as int).toList();
        print(laporanIds);

        setState(() {
          totalPekaCount = userLaporans.length;  // Count the number of laporans for the logged-in user
        });

        // Fetch tindaklanjuts based on laporanIds
        final tindaklanjutResponse = await dio.get('${url}tindaklanjuts');
        if (tindaklanjutResponse.statusCode == 202) {
          List tindaklanjuts = tindaklanjutResponse.data;
          print(tindaklanjuts);

          // Filter tindaklanjuts related to user's laporans by status
          List onProgressTindaklanjuts = tindaklanjuts.where((tindaklanjut) =>
          laporanIds.contains(tindaklanjut['laporan_id']) &&
              tindaklanjut['status'] == 'OnProcess').toList();
          print(onProgressTindaklanjuts);

          List closedTindaklanjuts = tindaklanjuts.where((tindaklanjut) =>
          laporanIds.contains(tindaklanjut['laporan_id']) &&
              tindaklanjut['status'] == 'Closed').toList();
          print(closedTindaklanjuts);

          setState(() {
            onProgressCount = onProgressTindaklanjuts.length;  // Count "On Progress" tindaklanjuts
            closedCount = closedTindaklanjuts.length;  // Count "Closed" tindaklanjuts
          });
        }
      }
    } catch (e) {
      print("Error fetching PEKA count or tindaklanjuts: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final globalState = Provider.of<GlobalStateFE>(context);
    var userName = box.read('userName');
    var userRole = box.read('userRole');
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LaporanListPage()),
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
      body: StreamBuilder<Object>(
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
                          '$userName',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '$userRole',
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
                                onTap: (){},
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _PekaCard(
                                title: 'On Progress',
                                icon: const Icon(Icons.access_time,
                                    color: Color.fromARGB(255, 20, 174, 92)),
                                count: onProgressCount,  // Update count from tindaklanjuts with status OnProcess
                                onTap: (){},
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
                                    color: Color.fromARGB(255, 255, 235, 19)),
                                count: closedCount,  // Update count from tindaklanjuts with status Closed
                                onTap: (){},
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
  final VoidCallback onTap;

  const _PekaCard({
    required this.title,
    required this.icon,
    required this.count,
    required this.onTap,
  });

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


