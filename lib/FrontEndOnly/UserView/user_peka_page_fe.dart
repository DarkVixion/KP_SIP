import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:fluttersip/FrontEndOnly/UserView/user_form_page_0_fe.dart';
import 'package:fluttersip/FrontEndOnly/Service/global_service_fe.dart';
import 'package:fluttersip/constants/constants.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class UserPekaPageFE extends StatefulWidget {
  final List<dynamic>? laporanIds;  // Optional list of laporan IDs for filtering

  const UserPekaPageFE({super.key, this.laporanIds});

  @override
  State<UserPekaPageFE> createState() => _UserPekaPageFEState();
}


class _UserPekaPageFEState extends State<UserPekaPageFE> {
  late Future<List<Map<String, dynamic>>> _fetchObservations = Future.value([]);
  final box = GetStorage();
  final Dio dio = Dio(); // Dio instance

  @override
  void initState() {
    super.initState();
    _fetchObservations = _fetchData(); // Initialize the Future
    setState(() {});  // Trigger UI update
  }


  Future<Uint8List?> _fetchImageWithTimeout(String imageUrl) async {
    try {
      // print('Fetching image from URL: $imageUrl');  // Log the image URL

      final response = await dio.get(
        imageUrl,
        options: Options(
          responseType: ResponseType.bytes,
          headers: {
            "Connection": "keep-alive",
          },
          receiveTimeout: const Duration(seconds: 10),
        ),
      );

      // print('Response status code: ${response.statusCode}');  // Log status code

      if (response.statusCode == 200) {
        return Uint8List.fromList(response.data);  // Return image bytes if successful
      } else {
        // print('Failed to fetch image, status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Unknown error: $e');
    }
    return null;
  }


  Future<void> fetchAllTipeObservasi(List<int> tipeObservasiIds) async {
    final token = box.read('token');

    // Fetch each TipeObservasi in parallel
    await Future.wait(tipeObservasiIds.map((id) async {
      try {
        var response = await dio.get(
          '${url}TipeObservasi/$id',
          options: Options(
            headers: {
              'Accept': 'application/json',
              'Authorization': 'Bearer $token', // Include the token
            },
          ),
        );

        if (response.statusCode == 203) {
          var responseBody = response.data;
          var tipeObservasiName = responseBody['nama'];
          print('tipe observasi = $tipeObservasiName');
          // Store the fetched TipeObservasi name in GetStorage using the ID as key
          box.write('tipeObservasi_$id', tipeObservasiName);
        } else {
          print('Error fetching TipeObservasi $id: ${response.data}');
        }
      } catch (e) {
        print('Exception fetching TipeObservasi $id: $e');
      }
    }));
  }

  Future<Map<int, Map<String, String>>> _fetchTindaklanjuts() async {
    final token = box.read('token');
    try {
      final response = await dio.get(
        '${url}tindaklanjuts',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',  // Use token for authorization
          },
        ),
      );

      if (response.statusCode == 202) {
        final List<dynamic> tindakLanjuts = response.data;

        // Map tindaklanjuts with laporan_id as the key and a map of 'status' and 'follow_up' as the value
        return {
          for (var tindakLanjutan in tindakLanjuts)
            tindakLanjutan['laporan_id']: {
              'status': tindakLanjutan['status'] ?? 'Unknown',
              'follow_up': tindakLanjutan['follow_up'] ?? 'Unknown',
            }
        };
      } else {
        throw Exception('Failed to fetch tindaklanjuts');
      }
    } catch (e) {
      throw Exception('Exception fetching tindaklanjuts: $e');
    }
  }

  Future<List<Map<String, dynamic>>> _fetchData() async {
    try {
      final response = await dio.get('${url}laporans');
      if (response.statusCode == 202) {
        final List<dynamic> data = response.data;
        var userId = box.read('userID');  // Get the logged-in user ID

        // Filter laporans for this user
        List<dynamic> userLaporans = data.where((item) => item['user_id'].toString() == userId).toList();

        // Fetch all tindaklanjuts and map them by laporan_id
        Map<int, Map<String, String>> tindakLanjutMap = await _fetchTindaklanjuts();

        // Sort by 'created_at' in descending order
        userLaporans.sort((a, b) => DateTime.parse(b['created_at']).compareTo(DateTime.parse(a['created_at'])));

        // Apply filter by laporanIds if provided
        if (widget.laporanIds != null ) {
          userLaporans = userLaporans.where((item) => widget.laporanIds!.contains(item['id'])).toList();
        }

        // Map user laporans and fetch status for each
        return userLaporans.map((item) {
          final tipeObservasiName = box.read('tipeObservasi_${item['tipe_observasi_id']}') ?? 'Unknown';
          final laporanId = item['id'];
          final tindakLanjutData = tindakLanjutMap[laporanId];
          final status = tindakLanjutData?['status'] ?? 'Unknown';
          final followUp = tindakLanjutData?['follow_up'] ?? 'Unknown';

          DateFormat dateFormat = DateFormat('yyyy/MM/dd HH:mm:ss');

          return {
            'timestamp': dateFormat.format(DateTime.parse(item['created_at'])),
            'answers': [
              {'answer': tipeObservasiName}
            ],
            'status': status,
            'follow_up': followUp,
            'img': item['img'],
          };
        }).toList();
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      throw Exception('Failed to load data: $e');
    }
  }


  @override
  Widget build(BuildContext context) {
    final globalState = Provider.of<GlobalStateFE>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[400],
        title: const Text('Daftar PEKA Saya', textAlign: TextAlign.center),
        automaticallyImplyLeading: false,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _fetchObservations,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No observations found.'));
          }

          var documents = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: documents.length,
            itemBuilder: (context, index) {
              var doc = documents[index];
              var answers = List<Map<String, dynamic>>.from(doc['answers']);
              var status = doc['status'];  // Fetch the status from the document
              var followUp = doc['follow_up'];

              return Container(
                padding: const EdgeInsets.all(16.0),
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blueGrey),
                  borderRadius: BorderRadius.circular(12.0),
                  color: Colors.white,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: answers.map((answer) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: doc['img'] != null && doc['img'].isNotEmpty
                                    ? FutureBuilder<Uint8List?>(
                                  future: _fetchImageWithTimeout('$url2${doc['img']}'),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState == ConnectionState.waiting) {
                                      return const CircularProgressIndicator(); // Show loading indicator while fetching
                                    }

                                    if (snapshot.hasError || !snapshot.hasData) {
                                      // Fallback image if there's an error or the image is null/empty
                                      return Image.network(
                                        'https://via.assets.so/img.jpg?w=50&h=50&tc=Black&bg=white&t=Tidak Ada Gambar',
                                        height: 100,
                                        width: 100,
                                        fit: BoxFit.cover,

                                      );
                                    }

                                    return Image.memory(
                                      snapshot.data!,
                                      height: 100,
                                      width: 100,
                                      fit: BoxFit.cover,
                                    );
                                  },
                                )
                                    : Image.network(
                                  'https://via.assets.so/img.jpg?w=50&h=50&tc=Black&bg=white&t=Tidak Ada Gambar',
                                  height: 100,
                                  width: 100,
                                  fit: BoxFit.cover, // Fallback image if img is null
                                ),
                              ),
                              const SizedBox(width: 8.0), // Space between image and text
                              Expanded(
                                child: Text(
                                  '${answer['answer']}',
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 8.0),

                    // Display the fetched status
                    Row(
                      children: [
                        const Text(
                          'Status:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          (status == null || status.trim().isEmpty) ? '-' : status,
                          style: const TextStyle(fontSize: 16, color: Colors.green),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8.0),
                    Row(
                      children: [
                        const Text(
                          'Follow Up:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          (followUp == null || followUp.trim().isEmpty) ? '-' : followUp,
                          style: const TextStyle(fontSize: 16, color: Colors.green),
                        ),
                      ],
                    ),
                    // Display timestamp
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Icon(
                          Icons.calendar_today, // Choose your preferred icon
                          color: Colors.grey[700],
                          size: 18, // Adjust the size as needed
                        ),
                        const SizedBox(width: 4),
                        Text(
                          doc['timestamp']?.toString() ?? 'No timestamp',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FloatingActionButton.extended(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const UserFormPage0FE()),
              );
            },
            label: const Text('Tambah PEKA'),
            icon: const Icon(Icons.add),
            backgroundColor: Colors.red,
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
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