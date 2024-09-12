import 'package:flutter/material.dart';
import 'package:fluttersip/FrontEndOnly/UserView/user_form_page_0_fe.dart';
import 'package:fluttersip/FrontEndOnly/Service/global_service_fe.dart';
import 'package:fluttersip/constants/constants.dart';
import 'package:get_storage/get_storage.dart';
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class UserPekaPageFE extends StatefulWidget {
  const UserPekaPageFE({super.key});

  @override
  State<UserPekaPageFE> createState() => _UserPekaPageFEState();
}

class _UserPekaPageFEState extends State<UserPekaPageFE> {
  late Future<List<Map<String, dynamic>>> _fetchObservations;
  final box = GetStorage();

  @override
  void initState() {
    super.initState();
    _fetchObservations = _fetchData(); // Initialize the Future
  }

  Future<void> fetchAllTipeObservasi(List<int> tipeObservasiIds) async {
    final token = box.read('token');

    // Fetch each TipeObservasi in parallel
    await Future.wait(tipeObservasiIds.map((id) async {
      try {
        var response = await http.get(
          Uri.parse('${url}TipeObservasi/$id'),
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $token', // Include the token
          },
        );

        if (response.statusCode == 205) {
          var responseBody = json.decode(response.body);
          var tipeObservasiName = responseBody['nama'];

          // Store the fetched TipeObservasi name in GetStorage using the ID as key
          box.write('tipeObservasi_$id', tipeObservasiName);
        } else {
          print('Error fetching TipeObservasi $id: ${response.body}');
        }
      } catch (e) {
        print('Exception fetching TipeObservasi $id: $e');
      }
    }));
  }

  Future<List<Map<String, dynamic>>> _fetchData() async {
    final response = await http.get(Uri.parse('${url}laporans'));

    if (response.statusCode == 202) {
      final List<dynamic> data = json.decode(response.body);
      var userId = box.read('userID');  // Fetch the logged-in user ID
      print('Fetched userID: $userId');

      // Filter the laporans based on the user ID
      List<dynamic> userLaporans = data.where((item) => item['user_id'].toString() == userId).toList();
      print('Filtered user laporans: $userLaporans');

      // Extract 'tipe_observasi_id' and ensure they are integers
      List<int> tipeObservasiIds = userLaporans.map<int>((item) => item['tipe_observasi_id']).toList();

      // Fetch and store TipeObservasi names
      await fetchAllTipeObservasi(tipeObservasiIds);

      // Map the observations to include the correct TipeObservasi name
      return userLaporans.map((item) {
        final tipeObservasiName = box.read('tipeObservasi_${item['tipe_observasi_id']}') ?? 'Unknown';
        return {
          'timestamp': DateTime.parse(item['tanggal']),
          'answers': [
            {'answer': tipeObservasiName}
          ],
          'img': item['img'], // Ensure 'img' field is passed
        };
      }).toList();

    } else {
      throw Exception('Failed to load data');
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
                                child: doc['img'] != null && doc['img'].contains('http')
                                    ? Image.network(
                                  doc['img'],
                                  height: 100,
                                  width: 100,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Image.network(
                                      'https://via.placeholder.com/200', // Fallback image in case of error
                                      height: 100,
                                      width: 100,
                                      fit: BoxFit.cover,
                                    );
                                  },
                                )
                                    : Image.network(
                                  'http://10.0.2.2:8000/storage/app/public/${doc['img']}', // Correct concatenation without extra slash
                                  height: 100,
                                  width: 100,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    print(error);
                                    return Image.network(
                                      'https://via.placeholder.com/300', // Fallback image in case of error
                                      height: 100,
                                      width: 100,
                                      fit: BoxFit.cover,
                                    );
                                  },
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
