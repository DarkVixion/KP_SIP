import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttersip/FrontEndOnly/Service/global_service_fe.dart';
import 'package:fluttersip/FrontEndOnly/UserView/user_form_page_0_fe.dart';
import 'package:fluttersip/constants/constants.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class AdminPekaPageFE extends StatefulWidget {
  const AdminPekaPageFE({super.key});

  @override
  State<AdminPekaPageFE> createState() => _AdminPekaPageFEState();
}

class _AdminPekaPageFEState extends State<AdminPekaPageFE> {
  late Future<List<Map<String, dynamic>>> _fetchObservations;
  final box = GetStorage();



  Future<List<Map<String, dynamic>>> _fetchData() async {
    final response = await http.get(Uri.parse('${url}laporans'));

    if (response.statusCode == 202) {
      final List<dynamic> data = json.decode(response.body);

      // Extracting the 'tipe_observasi_id' and ensuring they are integers
      List<int> tipeObservasiIds = data.map<int>((item) => item['tipe_observasi_id'] as int).toList();

      // Fetch all TipeObservasi
      await fetchAllTipeObservasi(tipeObservasiIds);

      return data.map((item) => {
        'timestamp': DateTime.parse(item['tanggal']),
        // 'img': item['img'], // Use placeholder if not valid
        'answers': [
          {'answer': box.read('tipeObservasi_${item['tipe_observasi_id']}') ?? 'Unknown'} // Use fetched TipeObservasi name
        ]
      }).toList();
    } else {
      throw Exception('Failed to load data');
    }
  }

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
                          child: FutureBuilder<String?>(
                            future: Future.value(doc['img']), // Use img from API
                            builder: (context, imageSnapshot) {
                              if (imageSnapshot.connectionState == ConnectionState.waiting) {
                                return const CircularProgressIndicator();
                              }

                              return Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Image.network(
                                      imageSnapshot.data ?? 'https://via.placeholder.com/100',
                                      height: 100, // Adjust size as needed
                                      width: 100, // Fixed width
                                      fit: BoxFit.cover,
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
                              );
                            },
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
