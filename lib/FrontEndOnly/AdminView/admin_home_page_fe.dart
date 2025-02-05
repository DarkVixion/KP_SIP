
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttersip/FrontEndOnly/AdminView/admin_peka_page_fe.dart';

import 'package:fluttersip/FrontEndOnly/Service/global_service_fe.dart';
import 'package:fluttersip/FrontEndOnly/profile_page_fe.dart';
import 'package:fluttersip/FrontEndOnly/test2.dart';
import 'package:fluttersip/constants/constants.dart';
import 'package:get/get.dart';

import 'package:get_storage/get_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';


class AdminHomePageFE extends StatefulWidget {
  const AdminHomePageFE({super.key});

  @override
  State<AdminHomePageFE> createState() => _AdminHomePageFEState();
}

class _AdminHomePageFEState extends State<AdminHomePageFE> {
  Dio dio = Dio();
  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  int totalThisMonthCount = 0; // Total count for this month
  int totalThisWeekCount = 0; // Total count for this week
  int totalThisMonthOpenCount = 0;
  int totalThisMonthClosedCount = 0;
  int totalThisMonthOnProcessCount = 0;
  int totalThisMonthRejectedCount = 0;
  int totalThisMonthOverdueCount = 0;
  int totalThisWeekOpenCount = 0;
  int totalThisWeekClosedCount = 0;
  int totalThisWeekOnProcessCount = 0;
  int totalThisWeekRejectedCount = 0;
  int totalThisWeekOverdueCount = 0;
  String selectedTimeFrame = 'month';
  String selectedTimeFrame2 = 'month';

  List<dynamic> ThisMonthTindakLanjuts = []; // Total count for this month
  List<dynamic> ThisWeekTindakLanjuts = []; // Total count for this week
  List<dynamic> totalThisMonthOpenTindakLanjuts = [];
  List<dynamic> totalThisMonthClosedTindakLanjuts = [];
  List<dynamic> totalThisMonthOnProcessTindakLanjuts = [];
  List<dynamic> totalThisMonthRejectedTindakLanjuts = [];
  List<dynamic> totalThisMonthOverdueTindakLanjuts = [];
  List<dynamic> totalThisWeekOpenTindakLanjuts = [];
  List<dynamic> totalThisWeekClosedTindakLanjuts = [];
  List<dynamic> totalThisWeekOnProcessTindakLanjuts = [];
  List<dynamic> totalThisWeekRejectedTindakLanjuts = [];
  List<dynamic> totalThisWeekOverdueTindakLanjuts = [];

  Future<void> _initializeData() async {
    fetchStatusMonthCounts();
    fetchStatusWeekCounts();

    fetchTindakLanjutsMonthWithStatusOpen();
    fetchTindakLanjutsMonthWithStatusClose();
    fetchTindakLanjutsMonthWithStatusOnProgress();
    fetchTindakLanjutsMonthWithStatusRejected();
    fetchTindakLanjutsMonthWithStatusOverdue();

    fetchTindakLanjutsWeekWithStatusOpen();
    fetchTindakLanjutsWeekWithStatusClose();
    fetchTindakLanjutsWeekWithStatusOnProgress();
    fetchTindakLanjutsWeekWithStatusRejected();
    fetchTindakLanjutsWeekWithStatusOverdue();

    setState(() {});  // Trigger UI update
  }

  Future<void> fetchStatusMonthCounts() async {
    try {
      final response = await dio.get('${url}tindaklanjuts/month');
      if (response.statusCode == 202) {
        final List<dynamic> tindaklanjuts = response.data;

        // Filter the data based on status and count
        setState(() {
          totalThisMonthCount = tindaklanjuts.length;
          ThisMonthTindakLanjuts = tindaklanjuts.toList();
        });
      }
    } catch (e) {
      //print("Error fetching Tindak Lanjut count: $e");
    }
  }
  Future<void> fetchTindakLanjutsMonthWithStatusOpen() async {
    try {
      // Make GET request to your Laravel API with status 'open'
      final response = await dio.get(
        '${url}tindaklanjuts/month',
        queryParameters: {'status': 'Open'},  // Add the status query parameter
      );

      if (response.statusCode == 202) {
        final List<dynamic> tindaklanjuts = response.data;

        setState(() {
          totalThisMonthOpenCount = tindaklanjuts.length;
          totalThisMonthOpenTindakLanjuts = tindaklanjuts.toList();
        });
      } else {
        throw Exception('Failed to load tindaklanjuts');
      }
    } catch (e) {
      throw Exception('Error fetching tindaklanjuts: $e');
    }
  }
  Future<void> fetchTindakLanjutsMonthWithStatusClose() async {
    try {
      // Make GET request to your Laravel API with status 'open'
      final response = await dio.get(
        '${url}tindaklanjuts/month',
        queryParameters: {'status': 'Closed'},  // Add the status query parameter
      );

      if (response.statusCode == 202) {
        final List<dynamic> tindaklanjuts = response.data;

        setState(() {
          totalThisMonthClosedCount = tindaklanjuts.length;
          totalThisMonthClosedTindakLanjuts = tindaklanjuts.toList();
        });
      } else {
        throw Exception('Failed to load tindaklanjuts');
      }
    } catch (e) {
      throw Exception('Error fetching tindaklanjuts: $e');
    }
  }
  Future<void> fetchTindakLanjutsMonthWithStatusOnProgress() async {
    try {
      // Make GET request to your Laravel API with status 'open'
      final response = await dio.get(
        '${url}tindaklanjuts/month',
        queryParameters: {'status': 'OnProcess'},  // Add the status query parameter
      );

      if (response.statusCode == 202) {
        final List<dynamic> tindaklanjuts = response.data;

        setState(() {
          totalThisMonthOnProcessCount = tindaklanjuts.length;
          totalThisMonthOnProcessTindakLanjuts = tindaklanjuts.toList();
        });
      } else {
        throw Exception('Failed to load tindaklanjuts');
      }
    } catch (e) {
      throw Exception('Error fetching tindaklanjuts: $e');
    }
  }
  Future<void> fetchTindakLanjutsMonthWithStatusRejected() async {
    try {
      // Make GET request to your Laravel API with status 'open'
      final response = await dio.get(
        '${url}tindaklanjuts/month',
        queryParameters: {'status': 'Rejected'},  // Add the status query parameter
      );

      if (response.statusCode == 202) {
        final List<dynamic> tindaklanjuts = response.data;

        setState(() {
          totalThisMonthRejectedCount = tindaklanjuts.length;
          totalThisMonthRejectedTindakLanjuts = tindaklanjuts.toList();
        });
      } else {
        throw Exception('Failed to load tindaklanjuts');
      }
    } catch (e) {
      throw Exception('Error fetching tindaklanjuts: $e');
    }
  }
  Future<void> fetchTindakLanjutsMonthWithStatusOverdue() async {
    try {
      // Make GET request to your Laravel API with status 'open'
      final response = await dio.get(
        '${url}tindaklanjuts/month',
        queryParameters: {'status': 'Overdue'},  // Add the status query parameter
      );

      if (response.statusCode == 202) {
        final List<dynamic> tindaklanjuts = response.data;

        setState(() {
          totalThisMonthOverdueCount = tindaklanjuts.length;
          totalThisMonthOverdueTindakLanjuts = tindaklanjuts.toList();
        });
      } else {
        throw Exception('Failed to load tindaklanjuts');
      }
    } catch (e) {
      throw Exception('Error fetching tindaklanjuts: $e');
    }
  }

  Future<void> fetchStatusWeekCounts() async {
    try {
      final response = await dio.get('${url}tindaklanjuts/week');
      if (response.statusCode == 202) {
        final List<dynamic> tindaklanjuts = response.data;

        // Filter the data based on status and count
        setState(() {
          totalThisWeekCount = tindaklanjuts.length;
          ThisWeekTindakLanjuts = tindaklanjuts.toList();
        });
      }
    } catch (e) {
      //print("Error fetching Tindak Lanjut count: $e");
    }
  }
  Future<void> fetchTindakLanjutsWeekWithStatusOpen() async {
    try {
      // Make GET request to your Laravel API with status 'open'
      final response = await dio.get(
        '${url}tindaklanjuts/week',
        queryParameters: {'status': 'Open'},  // Add the status query parameter
      );

      if (response.statusCode == 202) {
        final List<dynamic> tindaklanjuts = response.data;

        setState(() {
          totalThisWeekOpenCount = tindaklanjuts.length;
          totalThisWeekOpenTindakLanjuts = tindaklanjuts.toList();
        });
      } else {
        throw Exception('Failed to load tindaklanjuts');
      }
    } catch (e) {
      throw Exception('Error fetching tindaklanjuts: $e');
    }
  }
  Future<void> fetchTindakLanjutsWeekWithStatusClose() async {
    try {
      // Make GET request to your Laravel API with status 'open'
      final response = await dio.get(
        '${url}tindaklanjuts/week',
        queryParameters: {'status': 'Closed'},  // Add the status query parameter
      );

      if (response.statusCode == 202) {
        final List<dynamic> tindaklanjuts = response.data;

        setState(() {
          totalThisWeekClosedCount = tindaklanjuts.length;
          totalThisWeekClosedTindakLanjuts = tindaklanjuts.toList();
        });
      } else {
        throw Exception('Failed to load tindaklanjuts');
      }
    } catch (e) {
      throw Exception('Error fetching tindaklanjuts: $e');
    }
  }
  Future<void> fetchTindakLanjutsWeekWithStatusOnProgress() async {
    try {
      // Make GET request to your Laravel API with status 'open'
      final response = await dio.get(
        '${url}tindaklanjuts/week',
        queryParameters: {'status': 'OnProcess'},  // Add the status query parameter
      );

      if (response.statusCode == 202) {
        final List<dynamic> tindaklanjuts = response.data;

        setState(() {
          totalThisWeekOnProcessCount = tindaklanjuts.length;
          totalThisWeekOnProcessTindakLanjuts = tindaklanjuts.toList();
        });
      } else {
        throw Exception('Failed to load tindaklanjuts');
      }
    } catch (e) {
      throw Exception('Error fetching tindaklanjuts: $e');
    }
  }
  Future<void> fetchTindakLanjutsWeekWithStatusRejected() async {
    try {
      // Make GET request to your Laravel API with status 'open'
      final response = await dio.get(
        '${url}tindaklanjuts/week',
        queryParameters: {'status': 'Rejected'},  // Add the status query parameter
      );

      if (response.statusCode == 202) {
        final List<dynamic> tindaklanjuts = response.data;

        setState(() {
          totalThisWeekRejectedCount = tindaklanjuts.length;
          totalThisWeekRejectedTindakLanjuts = tindaklanjuts.toList();
        });
      } else {
        throw Exception('Failed to load tindaklanjuts');
      }
    } catch (e) {
      throw Exception('Error fetching tindaklanjuts: $e');
    }
  }
  Future<void> fetchTindakLanjutsWeekWithStatusOverdue() async {
    try {
      // Make GET request to your Laravel API with status 'open'
      final response = await dio.get(
        '${url}tindaklanjuts/week',
        queryParameters: {'status': 'Overdue'},  // Add the status query parameter
      );

      if (response.statusCode == 202) {
        final List<dynamic> tindaklanjuts = response.data;

        setState(() {
          totalThisWeekOverdueCount = tindaklanjuts.length;
          totalThisWeekOverdueTindakLanjuts = tindaklanjuts.toList();
        });
      } else {
        throw Exception('Failed to load tindaklanjuts');
      }
    } catch (e) {
      throw Exception('Error fetching tindaklanjuts: $e');
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

      // Define the URL of your Laravel backend that exports the tindaklanjuts data
      String link = selectedTimeFrame2 == 'week'
          ? "${url}download-data-xlsx-week"
          : "${url}download-data-xlsx-month"; // Change the URL based on selected time frame
      String fileName = selectedTimeFrame2 == 'week'
          ? "tindaklanjutsweek.xlsx"
          : "tindaklanjutsmonth.xlsx"; // Define the filename based on the time frame

      // Get the directory to save the file
      var dir = await getExternalStorageDirectory();

      // Check if the directory is null
      if (dir == null) {
        setState(() {
          isDownloading = false;
          progress = "Failed to get directory";
        });
        return; // Exit if directory is null
      }

      // Download the file using Dio
      await dio.download(
        link,
        "${dir.path}/$fileName",  // Save the file in the local directory
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

      // Display a SnackBar to notify the user about the download location
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("File saved to ${dir.path}/$fileName")),
      );
    } catch (e) {
      setState(() {
        isDownloading = false;
        progress = "Download Failed";
      });
      // print(e.toString());
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
            title: const Text('Admin Dashboard'),
            actions: [
              IconButton(
                onPressed: () {
                   Get.offAll(() => UserHomePageTest2());
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
                    if (selectedTimeFrame == 'month') ...[
                      Row(
                        children: [
                          Expanded(
                            child: _PekaCard(
                              title: 'Total PEKA',
                              icon: const Icon(Icons.layers,
                                color: Color.fromARGB(255, 103, 80, 164),),
                              count: totalThisMonthCount,
                              onTap: () {
                                List<int> tindakLanjutIds = ThisMonthTindakLanjuts.map((tindaklanjut) => tindaklanjut['id'] as int).toList();

                                Get.to(() => TindakLanjutPageFE(tindakLanjutIds: tindakLanjutIds));
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _PekaCard(
                              title: 'Open',
                              icon: const Icon(Icons.folder_open,
                                color: Color.fromARGB(255, 210, 157, 172),),
                              count: totalThisMonthOpenCount,
                              onTap: (){
                                List<int> tindakLanjutIds = totalThisMonthOpenTindakLanjuts.map((tindaklanjut) => tindaklanjut['id'] as int).toList();

                                Get.to(() => TindakLanjutPageFE(tindakLanjutIds: tindakLanjutIds));
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
                              count: totalThisMonthClosedCount,
                              onTap: () {
                                List<int> tindakLanjutIds = totalThisMonthClosedTindakLanjuts.map((tindaklanjut) => tindaklanjut['id'] as int).toList();

                                Get.to(() => TindakLanjutPageFE(tindakLanjutIds: tindakLanjutIds));
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                           Expanded(
                            child: _PekaCard(
                              title: 'On Progress',
                              icon: const Icon(Icons.access_time,
                                  color: Color.fromARGB(255, 192, 15, 12)),
                              count: totalThisMonthOnProcessCount,
                              onTap: () {
                                List<int> tindakLanjutIds = totalThisMonthOnProcessTindakLanjuts.map((tindaklanjut) => tindaklanjut['id'] as int).toList();

                                Get.to(() => TindakLanjutPageFE(tindakLanjutIds: tindakLanjutIds));
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
                              count: totalThisMonthRejectedCount, onTap: () {
                              List<int> tindakLanjutIds = totalThisMonthRejectedTindakLanjuts.map((tindaklanjut) => tindaklanjut['id'] as int).toList();
                              Get.to(() => TindakLanjutPageFE(tindakLanjutIds: tindakLanjutIds));
                            },
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _PekaCard(
                              title: 'Overdue',
                              icon: const Icon(Icons.calendar_today,
                                  color: Color.fromARGB(255, 117, 117, 117)),
                              count: totalThisMonthOverdueCount,
                              onTap: () {
                              List<int> tindakLanjutIds = totalThisMonthOverdueTindakLanjuts.map((tindaklanjut) => tindaklanjut['id'] as int).toList();

                              Get.to(() => TindakLanjutPageFE(tindakLanjutIds: tindakLanjutIds));
                            },
                            ),
                          ),
                        ],
                      ),
                    ],
                    if (selectedTimeFrame == 'week') ...[
                        Row(
                          children: [
                            Expanded(
                              child: _PekaCard(
                                title: 'Total PEKA',
                                icon: const Icon(Icons.layers,
                                  color: Color.fromARGB(255, 103, 80, 164),),
                                count: totalThisWeekCount,
                                onTap: () {
                                  List<int> tindakLanjutIds = ThisWeekTindakLanjuts.map((tindaklanjut) => tindaklanjut['id'] as int).toList();

                                  Get.to(() => TindakLanjutPageFE(tindakLanjutIds: tindakLanjutIds));
                                },
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _PekaCard(
                                title: 'Open',
                                icon: const Icon(Icons.folder_open,
                                  color: Color.fromARGB(255, 210, 157, 172),),
                                count: totalThisWeekOpenCount,
                                onTap: (){
                                  List<int> tindakLanjutIds = totalThisWeekOpenTindakLanjuts.map((tindaklanjut) => tindaklanjut['id'] as int).toList();

                                  Get.to(() => TindakLanjutPageFE(tindakLanjutIds: tindakLanjutIds));
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
                                count: totalThisWeekClosedCount,
                                onTap: () {
                                  List<int> tindakLanjutIds = totalThisWeekClosedTindakLanjuts.map((tindaklanjut) => tindaklanjut['id'] as int).toList();

                                  Get.to(() => TindakLanjutPageFE(tindakLanjutIds: tindakLanjutIds));
                                },
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _PekaCard(
                                title: 'On Progress',
                                icon: const Icon(Icons.access_time,
                                    color: Color.fromARGB(255, 192, 15, 12)),
                                count: totalThisWeekOnProcessCount, onTap: () {
                                List<int> tindakLanjutIds = totalThisWeekOnProcessTindakLanjuts.map((tindaklanjut) => tindaklanjut['id'] as int).toList();

                                Get.to(() => TindakLanjutPageFE(tindakLanjutIds: tindakLanjutIds));
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
                                count: totalThisWeekRejectedCount, onTap: () {
                                List<int> tindakLanjutIds = totalThisWeekRejectedTindakLanjuts.map((tindaklanjut) => tindaklanjut['id'] as int).toList();

                                Get.to(() => TindakLanjutPageFE(tindakLanjutIds: tindakLanjutIds));                              },
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _PekaCard(
                                title: 'Overdue',
                                icon: const Icon(Icons.calendar_today,
                                    color: Color.fromARGB(255, 117, 117, 117)),
                                count: totalThisWeekOverdueCount, onTap: () {
                                List<int> tindakLanjutIds = totalThisWeekOverdueTindakLanjuts.map((tindaklanjut) => tindaklanjut['id'] as int).toList();

                                Get.to(() => TindakLanjutPageFE(tindakLanjutIds: tindakLanjutIds));
                              },
                              ),
                            ),
                          ],
                        ),
                      ],
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Column(
                            children: [
                              CupertinoSlidingSegmentedControl<String>(
                                groupValue: selectedTimeFrame2,
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
                                    selectedTimeFrame2 = value ?? 'month';
                                    // print("Selected time frame: $selectedTimeFrame2");
                                  });
                                },
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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '$count',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 16),
                  icon,
                ],
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),

            ],
          ),
        ),
      ),
    );
  }
}
