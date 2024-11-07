import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:fluttersip/FrontEndOnly/UserView/user_form_page_0_fe.dart';
import 'package:fluttersip/FrontEndOnly/Service/global_service_fe.dart';
import 'package:fluttersip/constants/constants.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';

class UserHomePageTest extends StatefulWidget {
  final List<dynamic>? laporanIds;  // Optional list of laporan IDs for filtering

  const UserHomePageTest({super.key, this.laporanIds});

  @override
  State<UserHomePageTest> createState() => _UserHomePageTestState();
}

class _UserHomePageTestState extends State<UserHomePageTest> {
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
      if (response.statusCode == 200) {
        return Uint8List.fromList(response.data);  // Return image bytes if successful
      }
    } catch (e) {
      print('Error fetching image: $e');
    }
    return null;
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

      if (response.statusCode == 202 || response.statusCode == 200) {
        final List<dynamic> tindakLanjuts = response.data;

        // Debugging: Print fetched tindaklanjuts data
        print("Fetched tindaklanjuts data: $tindakLanjuts");

        // Map tindaklanjuts with laporan_id as the key and both status and follow_up as values
        return {
          for (var tindakLanjutan in tindakLanjuts)
            tindakLanjutan['laporan_id']: {
              'status': tindakLanjutan['status'] ?? 'No status',
              'follow_up': tindakLanjutan['follow_up'] ?? 'No follow-up'
            }
        };
      } else {
        throw Exception('Failed to fetch tindaklanjuts');
      }
    } catch (e) {
      print('Exception fetching tindaklanjuts: $e');
      return {};
    }
  }

  Future<List<Map<String, dynamic>>> _fetchData() async {
    final token = box.read('token');
    try {
      final response = await dio.get(
        '${url}laporans',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 202 || response.statusCode == 200) {
        final List<dynamic> data = response.data;
        final userId = box.read('userID');

        print("Fetched laporans data: $data");

        List<dynamic> userLaporans = data.where((item) => item['user_id'].toString() == userId).toList();

        Map<int, Map<String, String>> tindakLanjutMap = await _fetchTindaklanjuts();

        userLaporans.sort((a, b) => DateTime.parse(b['created_at']).compareTo(DateTime.parse(a['created_at'])));

        if (widget.laporanIds != null) {
          userLaporans = userLaporans.where((item) => widget.laporanIds!.contains(item['id'])).toList();
        }

        return userLaporans.map((item) {
          final tipeObservasiName = box.read('tipeObservasi_${item['tipe_observasi_id']}') ?? 'Unknown';
          final laporanId = item['id'];
          final tindakLanjutData = tindakLanjutMap[laporanId];

          // Retrieve both status and follow_up from tindakLanjutMap
          final status = tindakLanjutData?['status'] ?? 'Unknown';
          final followUp = tindakLanjutData?['follow_up'] ?? 'Unknown';

          // Debugging: Print each mapped data for verification
          print("Laporan ID: $laporanId, Status: $status, Follow Up: $followUp");

          return {
            'timestamp': DateTime.parse(item['created_at']),
            'answers': [
              {'answer': tipeObservasiName}
            ],
            'status': status,
            'follow_up': followUp,
            'img': item['img'],
          };
        }).toList();
      } else {
        print('Failed to load laporans: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Exception loading laporans: $e');
      return [];
    }
  }


  @override
  Widget build(BuildContext context) {
    final globalState = Provider.of<GlobalStateFE>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[400],
        title: const Text('Daftar PEKA Saya FE', textAlign: TextAlign.center),
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
              var status = doc['status'];
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
                                      return const CircularProgressIndicator();
                                    }

                                    if (snapshot.hasError || !snapshot.hasData) {
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
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(width: 8.0),
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
                    Row(
                      children: [
                        const Text(
                          'Status:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          status,
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
                          followUp,
                          style: const TextStyle(fontSize: 16, color: Colors.green),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Icon(
                          Icons.calendar_today,
                          color: Colors.grey[700],
                          size: 18,
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
    );
  }
}
