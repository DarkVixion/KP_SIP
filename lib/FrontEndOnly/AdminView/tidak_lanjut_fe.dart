import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttersip/FrontEndOnly/AdminView/admin_peka_page_fe.dart';
import 'package:fluttersip/constants/constants.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';

class TindaklanjutDetailPage extends StatefulWidget {
  final Map<String, dynamic> tindaklanjut;

  const TindaklanjutDetailPage({super.key, required this.tindaklanjut});

  @override
  _TindaklanjutDetailPageState createState() => _TindaklanjutDetailPageState();
}

class _TindaklanjutDetailPageState extends State<TindaklanjutDetailPage> {
  late String status;
  String? tipeNama;
  String? tipeObservasiId;

  @override
  void initState() {
    super.initState();
    // Extract the date part from the string (if available), else use one month after the current date
    String dateString = widget.tindaklanjut['tanggal'];
    String cleanedDate = dateString.split(' ')[0]; // Only take the first part before the space

    try {
      selectedTanggal = DateFormat('yyyy/MM/dd').parse(cleanedDate);
    } catch (e) {
      // If parsing fails, default to one month after the current date
      selectedTanggal = DateTime.now().add(const Duration(days: 60));
    }


    status = widget.tindaklanjut['status'];
    tipeObservasiId =widget.tindaklanjut['tipe'];
    fetchTipeObservasiNama();

  }


  Future<void> fetchTipeObservasiNama() async {
    Dio dio = Dio();
    final box = GetStorage();
    var token = box.read('token');


    try {
      final response = await dio.get(
        '${url}TipeObservasi/$tipeObservasiId',
        options: Options(
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $token', // Include the token
          },
        ),);

      if (response.statusCode == 203) {
        setState(() {
          tipeNama = response.data['nama']; // Assign the fetched nama
        });
      } else {
        print('Failed to fetch tipe observasi');
      }
    } catch (e) {
      print('Error fetching tipe observasi: $e');
    }
  }

  Future<void> updateStatus(String id, String newStatus, DateTime? selectedDate) async {
    Dio dio = Dio();
    final box = GetStorage();
    var token = box.read('token');

    if (selectedDate == null) {
      print('No selected date');
      return;
    }

    try {
      final response = await dio.put(
        '${url}tindaklanjut/$id/status',  // New endpoint to handle both
        data: {
          'status': newStatus,
          'tanggal_akhir': DateFormat('yyyy-MM-dd').format(selectedDate),
        },
        options: Options(
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        print('Status and Tanggal Akhir updated successfully');
      } else {
        print('Failed to update status and Tanggal Akhir');
      }
    } catch (e) {
      print('Error: $e');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[700],
        title: const Center(child: Text('Tindaklanjut Details')),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blueGrey.shade800),
                  borderRadius: BorderRadius.circular(0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Conditional image display
                    if (widget.tindaklanjut['img'] != null &&
                        widget.tindaklanjut['img'].isNotEmpty)
                      Column(
                        children: [
                          const Text(
                            'Image:',
                            style: TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 10),
                          Image.network(
                            headers: const {
                              'Accept': 'application/json',
                              'Connection' : 'keep-alive',
                            },
                            '${url2}${widget.tindaklanjut['img']}',
                            height: 200, // You can adjust the size
                            fit: BoxFit.cover,
                          ),
                          const SizedBox(height: 13),
                        ],
                      ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Deskripsi: ${widget.tindaklanjut['deskripsi']}',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                    const SizedBox(height: 13),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Tanggal Akhir Tindak Lanjut '),
                        _buildDatePickerContainer(),
                      ],
                    ),
                    const SizedBox(height: 13),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Tipe: ${tipeNama ?? 'Loading...'}',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                    const SizedBox(height: 13),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          status == 'Overdue' ? 'Status: Overdue' : 'Status: $status',
                          style: const TextStyle(fontSize: 16, color: Colors.red),  // Red text if overdue
                        ),
                      ],
                    ),
                    const SizedBox(height: 13),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Show the Process and Reject buttons when status is 'Open'
                        if (status == 'Open') ...[
                          ElevatedButton(
                            onPressed: () {
                              updateStatus(widget.tindaklanjut['id'], 'Rejected', selectedTanggal);
                              Get.offAll(() => const TindakLanjutPageFE());
                            },
                            child: const Text('Reject'),
                          ),
                          const SizedBox(width: 13),
                          ElevatedButton(
                            onPressed: () {
                              updateStatus(widget.tindaklanjut['id'], 'OnProcess', selectedTanggal);
                              Get.offAll(() => const TindakLanjutPageFE());
                            },
                            child: const Text('Process'),
                          ),
                          const SizedBox(width: 13),
                          ElevatedButton(
                            onPressed: () {
                              Get.back();
                            },
                            child: const Text(
                              'Back',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ],

                        // Show the Finish and Back buttons when status is 'OnProcess'
                        if (status == 'OnProcess' || status == 'Overdue') ...[
                          ElevatedButton(
                            onPressed: () {
                              updateStatus(widget.tindaklanjut['id'], 'Closed', selectedTanggal);
                              Get.offAll(() => const TindakLanjutPageFE());
                            },
                            child: const Text('Finish'),
                          ),
                          const SizedBox(width: 13),
                          ElevatedButton(
                            onPressed: () {
                              Get.back();
                            },
                            child: const Text('Back'),
                          ),
                        ],

                        // Default Back button if status is neither 'Open' nor 'OnProcess'
                        if (status != 'Open' && status != 'OnProcess' && status !='Overdue') ...[
                          ElevatedButton(
                            onPressed: () {
                              Get.back();
                            },
                            child: const Text(
                              'Back',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  DateTime? selectedTanggal;
  Future<void> _selectDate(BuildContext context) async {
    // Calculate one month after the selected date or current date
    DateTime oneMonthAfterSelected = (selectedTanggal ?? DateTime.now());

    // Calculate the end date (e.g., two weeks after one month)
    DateTime rangeEndDate = oneMonthAfterSelected.add(const Duration(days: 60));

    // Ensure the initial date is valid
    DateTime initialDate = selectedTanggal ?? oneMonthAfterSelected;

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: oneMonthAfterSelected,  // Start showing the picker 1 month after the current/selected date
      firstDate: oneMonthAfterSelected,    // The earliest selectable date is 1 month after
      lastDate: rangeEndDate,              // The latest selectable date is 2 weeks after that
    );

    if (pickedDate != null && pickedDate != selectedTanggal) {
      setState(() {
        selectedTanggal = pickedDate;
      });
    }
  }


  Widget _buildDatePickerContainer() {
    bool isButtonActive = !(status == 'OnProcess' || status == 'Rejected' || status == 'Closed'|| status == 'Overdue');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: isButtonActive ? () => _selectDate(context) : null,  // Disable if OnProcess or Rejected
          child: Container(
            padding: const EdgeInsets.symmetric(
              vertical: 12.0,
              horizontal: 16.0,
            ),
            decoration: BoxDecoration(
              border: Border.all(color: isButtonActive ? Colors.blueGrey : Colors.grey),  // Change color to grey when inactive
              borderRadius: BorderRadius.circular(0),
            ),
            child: Row(
              children: [
                Icon(Icons.calendar_today, color: isButtonActive ? Colors.blueGrey : Colors.grey),  // Change icon color when inactive
                const SizedBox(width: 8.0),
                Text(
                  DateFormat('dd/MM/yyyy').format(selectedTanggal ?? DateTime.now()),
                  style: TextStyle(
                    fontSize: 16.0,
                    color: isButtonActive ? Colors.black : Colors.grey,  // Change text color when inactive
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }



}
