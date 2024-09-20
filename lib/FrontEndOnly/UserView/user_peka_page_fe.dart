import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:fluttersip/FrontEndOnly/UserView/user_form_page_0_fe.dart';
import 'package:fluttersip/FrontEndOnly/Service/global_service_fe.dart';
import 'package:fluttersip/constants/constants.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';

class UserPekaPageFE extends StatefulWidget {
  const UserPekaPageFE({super.key});

  @override
  State<UserPekaPageFE> createState() => _UserPekaPageFEState();
}

class _UserPekaPageFEState extends State<UserPekaPageFE> {
  late Future<List<Map<String, dynamic>>> _fetchObservations;
  final box = GetStorage();
  final Dio dio = Dio(); // Dio instance

  @override
  void initState() {
    super.initState();
    _fetchObservations = _fetchData(); // Initialize the Future
  }

  Future<Uint8List?> _fetchImageWithTimeout(String imageUrl) async {
    try {
      final response = await dio.get(
        imageUrl,

        options: Options(
          responseType: ResponseType.bytes,
          headers: {
            "Connection" : "keep-alive",
          },
          receiveTimeout: const Duration(seconds: 10),
        ),
      );


      if (response.statusCode == 200) {
        return Uint8List.fromList(response.data);  // Return image bytes if successful
      }
    } catch (e) {
      print(e);
    }
    return null;
     // Return null if failed
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

  Future<List<Map<String, dynamic>>> _fetchData() async {
    try {
      final response = await dio.get('${url}laporans');

      if (response.statusCode == 202) {
        final List<dynamic> data = response.data;
        var userId = box.read('userID');  // Fetch the logged-in user ID


        // Filter the laporans based on the user ID
        List<dynamic> userLaporans = data.where((item) => item['user_id'].toString() == userId).toList();


        // Extract 'tipe_observasi_id' and ensure they are integers
        List<int> tipeObservasiIds = userLaporans.map<int>((item) => item['tipe_observasi_id']).toList();

        // Fetch and store TipeObservasi names
        await fetchAllTipeObservasi(tipeObservasiIds);

        // Sort userLaporans by 'created_at' in descending order
        userLaporans.sort((a, b) => DateTime.parse(b['created_at']).compareTo(DateTime.parse(a['created_at'])));

        // Map the observations to include the correct TipeObservasi name
        return userLaporans.map((item) {
          final tipeObservasiName = box.read('tipeObservasi_${item['tipe_observasi_id']}') ?? 'Unknown';
          return {
            'timestamp': DateTime.parse(item['created_at']),
            'answers': [
              {'answer': tipeObservasiName}
            ],
            'img': item['img'], // Ensure 'img' field is passed
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
                                  future: _fetchImageWithTimeout('${url2}${doc['img']}'),
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
                                        cacheWidth: null, // Disable caching
                                        cacheHeight: null, // Disable caching
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
