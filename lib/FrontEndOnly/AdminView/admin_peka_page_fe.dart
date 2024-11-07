import 'package:flutter/material.dart';
import 'package:fluttersip/FrontEndOnly/AdminView/tidak_lanjut_fe.dart';
import 'package:fluttersip/FrontEndOnly/Service/global_service_fe.dart';
import 'package:fluttersip/constants/constants.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class TindakLanjutPageFE extends StatefulWidget {
  final List<dynamic>? tindakLanjutIds;

  const TindakLanjutPageFE({super.key, this.tindakLanjutIds}); // Accept the filter in the constructor

  @override
  State<TindakLanjutPageFE> createState() => _TindakLanjutPageFEState();
}

class _TindakLanjutPageFEState extends State<TindakLanjutPageFE> {
  late Future<List<Map<String, dynamic>>> _fetchObservations = Future.value([]);
  final box = GetStorage();

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    _fetchObservations = _fetchData();  // Fetch observations
    setState(() {});  // Trigger UI update
  }

  Future<List<Map<String, dynamic>>> _fetchData() async {
    final token = box.read('token');

    try {
      var response = await http.get(
        Uri.parse('${url}tindaklanjuts'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 202) {
        final List<dynamic> data = json.decode(response.body);

        DateFormat dateFormat = DateFormat('yyyy/MM/dd');

        List<Map<String, dynamic>> tindaklanjuts = data.map((item) {
          return {
            'id': item['id'].toString(),
            'deskripsi': item['deskripsi'],
            'created_at': DateTime.parse(item['created_at']),
            'tanggal': dateFormat.format(DateTime.parse(item['tanggal'])),
            'status': item['status'],
            'tipe': item['tipe_observasi_id'].toString(),
            'img': item['img'],
            'tanggal_akhir': item['tanggal_akhir'],
            'lokasi': item['lokasi_id'].toString(),
            'detail_lokasi': item['detail_lokasi'],
            'kategori': item['kategori_id'].toString(),
            'clsr': item['clsr_id'].toString(),
            'direct_action': item['direct_action'],
            'non_clsr': item['non_clsr'],
            'follow_up': item['follow_up']
          };
        }).toList();
        // Try filtering again, printing ID types for each entry
        if (widget.tindakLanjutIds != null) {
          tindaklanjuts = tindaklanjuts.where((item) {
            bool matches = widget.tindakLanjutIds!.contains(int.tryParse(item['id']) ?? -1);
            return matches;
          }).toList();
        }

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
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Daftar PEKA Saya FE', textAlign: TextAlign.center),
          ],
        ),
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
              var selectedTindaklanjut = tindaklanjuts[index];

              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TindaklanjutDetailPage(tindaklanjut: tindaklanjuts[index]),
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
                      Row(
                        children: [
                          Text(
                            '${selectedTindaklanjut['deskripsi']}',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            'Status : ${selectedTindaklanjut['status']}',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8.0),
                      Row(
                        children: [
                          Text(
                            'Tanggal Akhir Tindak Lanjut : ${selectedTindaklanjut['tanggal_akhir'] ?? '-'}',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8.0),
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_today,
                            color: Colors.grey[700],
                            size: 18,
                          ),
                          const SizedBox(width: 4),
                          Text(
                              DateFormat('dd/MM/yyyy HH:mm:ss').format(selectedTindaklanjut['created_at']).toString(),
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
