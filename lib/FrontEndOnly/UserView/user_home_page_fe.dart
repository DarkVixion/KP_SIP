import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttersip/FrontEndOnly/Service/global_service_fe.dart';
import 'package:fluttersip/FrontEndOnly/UserView/user_peka_page_fe.dart';
import 'package:fluttersip/FrontEndOnly/profile_page_fe.dart';
import 'package:fluttersip/FrontEndOnly/test2.dart';
import 'package:fluttersip/constants/constants.dart';
import 'package:fluttersip/testcode.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
// Import for date handling
import 'package:provider/provider.dart';


class UserHomePageFE extends StatefulWidget {
  const UserHomePageFE({super.key});

  @override
  State<UserHomePageFE> createState() => _UserHomePageFEState();
}

class _UserHomePageFEState extends State<UserHomePageFE> {
  final box = GetStorage();

  int totalThisMonthCount = 0; // Total count for this month
  int totalThisWeekCount = 0; // Total count for this week
  int thisMonthOnProgressCount = 0;
  int thisMonthClosedCount = 0;
  int thisWeekOnProgressCount = 0;
  int thisWeekClosedCount = 0;
  String selectedTimeFrame = 'month';


  @override
  void initState() {
    super.initState();
    var userID = box.read('userID');
    Provider.of<GlobalStateFE>(context, listen: false).updateUserId(userID);
    fetchPekaMonthCount();
    fetchPekaWeekCount();  // Fetch the laporan count and tindaklanjuts for the logged-in user
  }




  Future<void> fetchPekaMonthCount() async {
    Dio dio = Dio();
    var userId = int.parse(box.read('userID')); // Get the user ID from GetStorage

    try {
      // Fetch laporans
      final laporansResponse = await dio.get('${url}laporans/month');
      if (laporansResponse.statusCode == 202) {
        List laporans = laporansResponse.data;

        // Filter laporans by user ID
        List userLaporans = laporans.where((laporan) => laporan['user_id'] == userId).toList();
        List<int> laporanIds = userLaporans.map<int>((laporan) => laporan['id'] as int).toList();


        // Fetch tindaklanjuts
        final tindaklanjutMonthResponse = await dio.get('${url}tindaklanjuts/month');
        if (tindaklanjutMonthResponse.statusCode == 202) {
          List tindaklanjuts = tindaklanjutMonthResponse.data;
          List<int> tindaklanjutIds = tindaklanjuts.map((tindaklanjut) => tindaklanjut['laporan_id'] as int).toList();

          List<int> matchingIds = laporanIds.where((id) => tindaklanjutIds.contains(id)).toList();

          setState(() {
            thisMonthLaporansID = matchingIds;
            totalThisMonthCount = matchingIds.length;
          });
        }

        // Fetch tindaklanjuts with status "OnProcess", "Open", and "Overdue"
        final tindaklanjutOnProcessResponse = await dio.get(
          '${url}tindaklanjuts/month',
          queryParameters: {'status[]': ['OnProcess', 'Overdue', 'Open']},
        );
        if (tindaklanjutOnProcessResponse.statusCode == 202) {
          List tindaklanjuts = tindaklanjutOnProcessResponse.data;
          List<int> tindaklanjutIds = tindaklanjuts.map((tindaklanjut) => tindaklanjut['laporan_id'] as int).toList();
          List<int> matchingOnProcessIds = laporanIds.where((id) => tindaklanjutIds.contains(id)).toList();

          setState(() {
            thisMonthOnProgressTindaklanjuts = matchingOnProcessIds;
            thisMonthOnProgressCount = matchingOnProcessIds.length;
          });
        }

        // Fetch tindaklanjuts with status "Closed" or "Rejected"
        final tindaklanjutClosedResponse = await dio.get(
          '${url}tindaklanjuts/month',
          queryParameters: {'status[]': ['Closed', 'Rejected']},
        );
        if (tindaklanjutClosedResponse.statusCode == 202) {
          List tindaklanjuts = tindaklanjutClosedResponse.data;
          List<int> tindaklanjutIds = tindaklanjuts.map((tindaklanjut) => tindaklanjut['laporan_id'] as int).toList();
          List<int> matchingClosedIds = laporanIds.where((id) => tindaklanjutIds.contains(id)).toList();

          setState(() {
            thisMonthClosedTindaklanjuts = matchingClosedIds;
            thisMonthClosedCount = matchingClosedIds.length;
          });
        }
      }
    } catch (e) {
      print("Error fetching PEKA count or tindaklanjuts: $e");
    }
  }

  Future<void> fetchPekaWeekCount() async {
    Dio dio = Dio();
    var userId = int.parse(box.read('userID'));  // Get the user ID from GetStorage

    try {
      // Fetch laporans
      final laporansResponse = await dio.get('${url}laporans/week');
      if (laporansResponse.statusCode == 202) {
        List laporans = laporansResponse.data;

        // Filter laporans by user ID
        List userLaporans = laporans.where((laporan) => laporan['user_id'] == userId).toList();
        List<int> laporanIds = userLaporans.map<int>((laporan) => laporan['id'] as int).toList();



        // Fetch tindaklanjuts
        final tindaklanjutWeekResponse = await dio.get('${url}tindaklanjuts/week');
        if (tindaklanjutWeekResponse.statusCode == 202) {
          List tindaklanjuts = tindaklanjutWeekResponse.data;
          List<int> tindaklanjutIds = tindaklanjuts.map((tindaklanjut) => tindaklanjut['laporan_id'] as int).toList();

          List<int> matchingIds = laporanIds.where((id) => tindaklanjutIds.contains(id)).toList();

          setState(() {
            thisWeekLaporansID = matchingIds;
            totalThisWeekCount = matchingIds.length;
          });
        }

        // Fetch tindaklanjuts with status "OnProcess", "Open", and "Overdue"
        final tindaklanjutOnProcessResponse = await dio.get(
          '${url}tindaklanjuts/week',
          queryParameters: {'status[]': ['OnProcess', 'Open', 'Overdue']},
        );
        if (tindaklanjutOnProcessResponse.statusCode == 202) {
          List tindaklanjuts = tindaklanjutOnProcessResponse.data;
          List<int> tindaklanjutIds = tindaklanjuts.map((tindaklanjut) => tindaklanjut['laporan_id'] as int).toList();
          List<int> matchingOnProcessIds = laporanIds.where((id) => tindaklanjutIds.contains(id)).toList();

          setState(() {
            thisWeekOnProgressTindaklanjuts = matchingOnProcessIds;
            thisWeekOnProgressCount = matchingOnProcessIds.length;
          });
        }

        // Fetch tindaklanjuts with status "Closed" or "Rejected"
        final tindaklanjutClosedResponse = await dio.get(
          '${url}tindaklanjuts/week',
          queryParameters: {'status[]': ['Closed', 'Rejected']},
        );
        if (tindaklanjutClosedResponse.statusCode == 202) {
          List tindaklanjuts = tindaklanjutClosedResponse.data;
          List<int> tindaklanjutIds = tindaklanjuts.map((tindaklanjut) => tindaklanjut['laporan_id'] as int).toList();
          List<int> matchingClosedIds = laporanIds.where((id) => tindaklanjutIds.contains(id)).toList();

          setState(() {
            thisWeekClosedTindaklanjuts = matchingClosedIds;
            thisWeekClosedCount = matchingClosedIds.length;
          });
        }
      }
    } catch (e) {
      print("Error fetching PEKA count or tindaklanjuts: $e");
    }
  }


  List<dynamic> thisMonthLaporansID = [];
  List<dynamic> thisWeekLaporansID = [];
  List<dynamic> thisMonthOnProgressTindaklanjuts = [];
  List<dynamic> thisMonthClosedTindaklanjuts =[];
  List<dynamic> thisWeekClosedTindaklanjuts =[];
  List<dynamic> thisWeekOnProgressTindaklanjuts =[];


  @override
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
                MaterialPageRoute(builder: (context) => const UserHomePageTest()),
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
                                CupertinoSlidingSegmentedControl<String>(
                                  groupValue: selectedTimeFrame,
                                  children: {
                                    'month': Container(
                                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                                      child: const Text(
                                        'Month',
                                        style: TextStyle(color: Colors.black), // Active text color
                                      ),
                                    ),
                                    'week': Container(
                                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                                      child: const Text(
                                        'Week',
                                        style: TextStyle(color: Colors.black), // Active text color
                                      ),
                                    ),
                                  },
                                  thumbColor: Colors.red, // Color of the selected segment
                                  backgroundColor: Colors.grey, // Background color of the unselected segments
                                  onValueChanged: (value) {
                                    setState(() {
                                      selectedTimeFrame = value ?? 'month';
                                      // print("Selected time frame: $selectedTimeFrame");
                                    });
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        // Show Monthly cards if selectedTimeFrame is 'month'
                        if (selectedTimeFrame == 'month') ...[
                          Row(
                            children: [
                              Expanded(
                                child: _PekaCard(
                                  title: 'Total PEKA',
                                  icon: const Icon(Icons.layers, color: Color.fromARGB(255, 236, 34, 31)),
                                  count: totalThisMonthCount,
                                  onTap: () {
                                    // Directly use thisMonthLaporansID since it already contains IDs
                                    List<int> laporanIds = List<int>.from(thisMonthLaporansID);

                                    Get.to(() => UserPekaPageFE(laporanIds: laporanIds));
                                  },
                                ),
                              ),
                              const SizedBox(width: 16),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: _PekaCard(
                                  title: 'On Progress',
                                  icon: const Icon(Icons.access_time, color: Color.fromARGB(255, 20, 174, 92)),
                                  count: thisMonthOnProgressCount,
                                  onTap: () {
                                    // Directly use thisMonthOnProgressTindaklanjuts since it already contains IDs
                                    List<int> laporanIds = List<int>.from(thisMonthOnProgressTindaklanjuts);

                                    Get.to(() => UserPekaPageFE(laporanIds: laporanIds));
                                  },
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: _PekaCard(
                                  title: 'Closed',
                                  icon: const Icon(Icons.checklist, color: Color.fromARGB(255, 255, 235, 19)),
                                  count: thisMonthClosedCount,
                                  onTap: () {
                                    // Directly use thisMonthClosedTindaklanjuts since it already contains IDs
                                    List<int> laporanIds = List<int>.from(thisMonthClosedTindaklanjuts);

                                    Get.to(() => UserPekaPageFE(laporanIds: laporanIds));
                                  },
                                ),
                              ),
                            ],
                          ),

                        ],
                        // Show Weekly cards if selectedTimeFrame is 'week'
                        if (selectedTimeFrame == 'week') ...[
                          Row(
                            children: [
                              Expanded(
                                child: _PekaCard(
                                  title: 'Total PEKA',
                                  icon: const Icon(Icons.layers, color: Color.fromARGB(255, 236, 34, 31)),
                                  count: totalThisWeekCount,
                                  onTap: () {
                                    // Directly use thisWeekLaporansID since it already contains IDs
                                    List<int> laporanIds = List<int>.from(thisWeekLaporansID);

                                    Get.to(() => UserPekaPageFE(laporanIds: laporanIds));
                                  },
                                ),
                              ),
                              const SizedBox(width: 16),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: _PekaCard(
                                  title: 'On Progress',
                                  icon: const Icon(Icons.access_time, color: Color.fromARGB(255, 20, 92, 174)),
                                  count: thisWeekOnProgressCount,
                                  onTap: () {
                                    // Directly use thisWeekOnProgressTindaklanjuts since it already contains IDs
                                    List<int> laporanIds = List<int>.from(thisWeekOnProgressTindaklanjuts);

                                    Get.to(() => UserPekaPageFE(laporanIds: laporanIds));
                                  },
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: _PekaCard(
                                  title: 'Closed',
                                  icon: const Icon(Icons.checklist, color: Color.fromARGB(255, 255, 235, 19)),
                                  count: thisWeekClosedCount,
                                  onTap: () {
                                    // Directly use thisWeekClosedTindaklanjuts since it already contains IDs
                                    List<int> laporanIds = List<int>.from(thisWeekClosedTindaklanjuts);
                                    Get.to(() => UserPekaPageFE(laporanIds: laporanIds));
                                  },
                                ),
                              ),
                            ],
                          ),

                        ],
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
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
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    count.toString(),
                    style: const TextStyle(fontSize: 20),
                  ),
                  const SizedBox(width: 8),
                  icon,
                ],
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
