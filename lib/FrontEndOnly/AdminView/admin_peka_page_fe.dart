import 'package:flutter/material.dart';
import 'package:fluttersip/FrontEndOnly/AdminView/tidak_lanjut_fe.dart';
import 'package:fluttersip/FrontEndOnly/Service/global_service_fe.dart';
import 'package:fluttersip/constants/constants.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
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

    // Step 2: Fetch observations after TipeObservasi has been fetched
    _fetchObservations = _fetchData();  // Fetch observations
    setState(() {});  // Trigger UI update
  }



  Future<List<Map<String, dynamic>>> _fetchData() async {
    final token = box.read('token');  // Assuming the token is needed for authorization

    try {
      var response = await http.get(
        Uri.parse('${url}tindaklanjuts'),  // Assuming this is the correct endpoint for tindaklanjuts
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',  // Include the token if necessary
        },
      );

      if (response.statusCode == 202) {
        final List<dynamic> data = json.decode(response.body);

        DateFormat dateFormat = DateFormat('yyyy/MM/dd');

        // Map the data and include only 'deskripsi' and 'tanggal'
        List<Map<String, dynamic>> tindaklanjuts = data.map((item) {
          return {
            'deskripsi': item['deskripsi'],
            'created_at': DateTime.parse(item['created_at']),
            'tanggal': dateFormat.format(DateTime.parse(item['tanggal'])),
            'status': item['status'],
            'tipe': item['tipe'],
            'img': item['img'], // If you want to include an image
          };
        }).toList();

        // Sort by 'tanggal' (newest first)
        tindaklanjuts.sort((a, b) => b['created_at'].compareTo(a['created_at']));

        return tindaklanjuts;
      } else {
        throw Exception('Failed to load tindaklanjuts');
      }
    } catch (e) {
      print('Error fetching tindaklanjuts: $e');
      throw Exception('Failed to load tindaklanjuts');
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
            return const Center(child: Text('No tindaklanjuts found.'));
          }

          var tindaklanjuts = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: tindaklanjuts.length,
            itemBuilder: (context, index) {
              var tindaklanjut = tindaklanjuts[index];

              return InkWell(
                onTap: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TindaklanjutDetailPage(tindaklanjut: tindaklanjut),
                    ),
                  );
                },
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
                      Text(
                        '${tindaklanjut['deskripsi']}',
                        style: const TextStyle(fontSize: 16),
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
                            tindaklanjut['created_at'].toString(),
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

