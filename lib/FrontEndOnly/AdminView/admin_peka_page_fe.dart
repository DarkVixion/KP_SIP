import 'package:flutter/material.dart';
import 'package:fluttersip/FrontEndOnly/Service/global_service_fe.dart';
import 'package:fluttersip/constants/constants.dart';
import 'package:get_storage/get_storage.dart';
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class AdminPekaPageFE extends StatefulWidget {
  const AdminPekaPageFE({super.key});

  @override
  State<AdminPekaPageFE> createState() => _AdminPekaPageFEState();
}

class _AdminPekaPageFEState extends State<AdminPekaPageFE> {
  late Future<List<Map<String, dynamic>>> _fetchObservations = Future.value([]); // Initialize with an empty Future
  final box = GetStorage();

  @override
  void initState() {
    super.initState();
    _initializeData();  // Fetch data during initialization
  }

  Future<void> _initializeData() async {
    // Step 1: Fetch and store TipeObservasi first
    await _fetchAllTipeObservasi();

    // Step 2: Fetch observations after TipeObservasi has been fetched
    _fetchObservations = _fetchData();  // Fetch observations
    setState(() {});  // Trigger UI update
  }

  // Fetch all available TipeObservasi and store in GetStorage
  Future<void> _fetchAllTipeObservasi() async {
    final token = box.read('token');

    try {
      var response = await http.get(
        Uri.parse('${url}TipeObservasi'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token', // Include the token
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> tipeObservasiList = json.decode(response.body);

        // Store each TipeObservasi name by its ID in GetStorage
        for (var tipeObservasi in tipeObservasiList) {
          int id = tipeObservasi['id'];
          String name = tipeObservasi['nama'];
          box.write('tipeObservasi_$id', name);  // Store in GetStorage
        }
      } else {
        print('Failed to fetch TipeObservasi: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching TipeObservasi: $e');
    }
  }

  Future<List<Map<String, dynamic>>> _fetchData() async {
    final response = await http.get(Uri.parse('${url}laporans'));

    if (response.statusCode == 202) {
      final List<dynamic> data = json.decode(response.body);

      // Map the data and include the necessary fields
      List<Map<String, dynamic>> observations = data.map((item) {
        int tipeObservasiId = item['tipe_observasi_id'];
        String tipeObservasiName = box.read('tipeObservasi_$tipeObservasiId') ?? 'Unknown';

        return {
          'timestamp': DateTime.parse(item['tanggal']),
          'answers': [
            {'answer': tipeObservasiName}  // Use the stored TipeObservasi name
          ]
        };
      }).toList();

      // Sort the observations by timestamp (newest first)
      observations.sort((a, b) => b['timestamp'].compareTo(a['timestamp']));

      return observations;
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
        future: _fetchObservations,  // Use the _fetchObservations Future
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

              return InkWell(
                  onTap: () {},
                child: Container(
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
                              future: Future.value(doc['img']),
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
                                );
                              },
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 8.0),
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
                ),
              );
            },
          );
        },
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

