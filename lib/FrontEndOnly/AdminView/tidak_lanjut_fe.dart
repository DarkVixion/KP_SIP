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
  String? lokasiNama;
  String? clsrNama;
  String? clsrDeskripsi;
  String? kategoriNama;
  String? clsrId;
  String? kategoriId;
  String? tipeObservasiId;
  String? lokasiId;
  String? nonClsr;

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
    lokasiId = widget.tindaklanjut['lokasi'];
    fetchLokasiNama();
    clsrId = widget.tindaklanjut['clsr'];
    fetchClsrNama();
    kategoriId = widget.tindaklanjut['kategori'];
    fetchKategoriNama();

  }


  Future<void> fetchTipeObservasiNama() async {
    Dio dio = Dio();
    final box = GetStorage();
    var token = box.read('token');


    try {
      final response = await dio.get(
        '${url}TipeObservasiT/$tipeObservasiId',
        options: Options(
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $token', // Include the token
          },
        ),);

      if (response.statusCode == 200) {
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
  Future<void> fetchLokasiNama() async {
    Dio dio = Dio();
    final box = GetStorage();
    var token = box.read('token');


    try {
      final response = await dio.get(
        '${url}LokasiT/$lokasiId',
        options: Options(
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $token', // Include the token
          },
        ),);

      if (response.statusCode == 200) {
        setState(() {
          lokasiNama = response.data['nama']; // Assign the fetched nama
        });
      } else {
        print('Failed to fetch Lokasi');
      }
    } catch (e) {
      print('Error fetching Lokasi: $e');
    }
  }

  Future<void> fetchClsrNama() async {
    Dio dio = Dio();
    final box = GetStorage();
    var token = box.read('token');


    try {
      final response = await dio.get(
        '${url}CLSRT/$clsrId',
        options: Options(
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $token', // Include the token
          },
        ),);

      if (response.statusCode == 200) {
        setState(() {
          clsrNama = response.data['nama']; // Assign the fetched nama
          clsrDeskripsi = response.data['deskripsi'];
        });
      } else {
        print('Failed to fetch CLSR');
      }
    } catch (e) {
      print('Error fetching CLSR: $e');
    }
  }

  Future<void> fetchKategoriNama() async {
    Dio dio = Dio();
    final box = GetStorage();
    var token = box.read('token');


    try {
      final response = await dio.get(
        '${url}KategoriT/$kategoriId',
        options: Options(
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $token', // Include the token
          },
        ),);

      if (response.statusCode == 200) {
        setState(() {
          kategoriNama = response.data['nama']; // Assign the fetched nama
        });
      } else {
        print('Failed to fetch Lokasi');
      }
    } catch (e) {
      print('Error fetching Lokasi: $e');
    }
  }

  Future<void> updateStatus(String id, String newStatus, DateTime? selectedDate, String followUpDetails) async {
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
          'follow_up': followUpDetails,  // Send the follow-up details here
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
    nonClsr = widget.tindaklanjut['non_clsr'];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[700],
        title: const Center(child: Text('Tindaklanjut Details')),
        automaticallyImplyLeading: false,
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
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                            '$url2${widget.tindaklanjut['img']}',
                            height: 200, // You can adjust the size
                            fit: BoxFit.cover,
                          ),
                          const SizedBox(height: 13),
                        ],
                      ),
                    Row(
                      children: [
                        Text(
                          'Deskripsi: ${widget.tindaklanjut['deskripsi']}',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                    const SizedBox(height: 13),
                    Row(
                      children: [
                        const Text('Tanggal Akhir Tindak Lanjut '),
                        _buildDatePickerContainer(),
                      ],
                    ),
                    const SizedBox(height: 13),
                    Row(
                      children: [
                        Text(
                          'Tipe: ${tipeNama ?? 'Loading...'}',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                    const SizedBox(height: 13),
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            'Lokasi : ${lokasiNama ?? 'Loading...'}',
                            style: const TextStyle(fontSize: 16),
                            maxLines: 2, // Allows wrapping the text to two lines
                            overflow: TextOverflow.visible,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 13),
                    Row(
                      children: [
                        Text(
                          'Detail Lokasi : ${widget.tindaklanjut['detail_lokasi']}',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                    const SizedBox(height: 13),
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            'Kategori : ${kategoriNama ?? 'Loading...'}',
                            style: const TextStyle(fontSize: 16),
                            maxLines: 2, // Allows wrapping the text to two lines
                            overflow: TextOverflow.visible, // Shows overflowing text
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 13),
                    if(widget.tindaklanjut['clsr'] == '450')...[
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              'Non CLSR : ${nonClsr ?? 'No'} ',
                              style: const TextStyle(fontSize: 16),
                              maxLines: 2, // Allows wrapping the text to two lines
                              overflow: TextOverflow.visible, // Shows overflowing text
                            ),
                          ),
                        ],
                      ),
                    ],
                    if (widget.tindaklanjut['clsr'] != '450')...[
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              'CLSR : ${clsrNama ?? 'Loading...'} - $clsrDeskripsi',
                              style: const TextStyle(fontSize: 16),
                              maxLines: 2, // Allows wrapping the text to two lines
                              overflow: TextOverflow.visible, // Shows overflowing text
                            ),
                          ),
                        ],
                      ),
                    ],
                    const SizedBox(height: 13),
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            'Direct Action : ${widget.tindaklanjut['direct_action']}',
                            style: const TextStyle(fontSize: 16),
                            maxLines: 2, // Allows wrapping the text to two lines
                            overflow: TextOverflow.visible,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 13),
                    Row(
                      children: [
                        Text(
                          status == 'Overdue' ? 'Status: Overdue' : 'Status: $status',
                          style: const TextStyle(fontSize: 16,),  // Red text if overdue
                        ),
                      ],
                    ),
                    const SizedBox(height: 13),
                    Row(
                      children: [
                        if (status != 'Open') ...[
                          Flexible(
                            child: Text(
                              'Follow Up : ${widget.tindaklanjut['follow_up']}',
                              style: const TextStyle(fontSize: 16),
                              maxLines: 2, // Allows wrapping the text to two lines
                              overflow: TextOverflow.visible,
                            ),
                          ),
                        ],
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Show the Process and Reject buttons when status is 'Open'
                        if (status == 'Open') ...[
                          ElevatedButton(
                            onPressed: () {
                              Get.back();
                            },
                            child: const Text(
                              'Back',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                          const SizedBox(width: 13),
                          ElevatedButton(
                            onPressed: () {
                              TextEditingController rejectReasonController = TextEditingController();

                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text('Konfirmasi Penolakan'),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Text('Masukan Alasan Penolakan PEKA :'),
                                        const SizedBox(height: 10),
                                        TextFormField(
                                          controller: rejectReasonController,
                                          decoration: const InputDecoration(
                                            hintText: 'Alasan Penolakan',
                                            border: OutlineInputBorder(),
                                          ),
                                          maxLines: 2,
                                        ),
                                      ],
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Get.back();  // Close the dialog
                                        },
                                        child: const Text('Cancel'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          // Call updateStatus with the rejection reason
                                          updateStatus(
                                            widget.tindaklanjut['id'],
                                            'Rejected',
                                            selectedTanggal,
                                            rejectReasonController.text,  // Pass rejection reason to the API
                                          );
                                          // Close the dialog and navigate
                                          Get.back();
                                          Get.offAll(() => const TindakLanjutPageFE());
                                        },
                                        child: const Text('Confirm'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            child: const Text('Reject'),
                          ),

                          const SizedBox(width: 13),
                          ElevatedButton(
                            onPressed: () {
                              TextEditingController followUpController = TextEditingController();

                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text('Konfirmasi Proses'),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Text('Masukan detail follow-Up untuk proses PEKA :'),
                                        const SizedBox(height: 10),
                                        TextFormField(
                                          controller: followUpController,
                                          decoration: const InputDecoration(
                                            hintText: 'Detail Follow-Up',
                                            border: OutlineInputBorder(),
                                          ),
                                          maxLines: 2,
                                        ),
                                      ],
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Get.back();  // Close the dialog
                                        },
                                        child: const Text('Cancel'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          // Get the follow-up details from the text field
                                          String followUpDetails = followUpController.text;

                                          // Call updateStatus with the follow-up details
                                          updateStatus(
                                            widget.tindaklanjut['id'],
                                            'OnProcess',
                                            selectedTanggal,
                                            followUpDetails,  // Pass follow-up to the API
                                          );

                                          // Close the dialog and navigate
                                          Get.back();
                                          Get.offAll(() => const TindakLanjutPageFE());
                                        },
                                        child: const Text('Confirm'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            child: const Text('Process'),
                          ),


                        ],

                        // Show the Finish and Back buttons when status is 'OnProcess'
                        if (status == 'OnProcess' || status == 'Overdue') ...[
                          ElevatedButton(
                            onPressed: () {
                              Get.back();
                            },
                            child: const Text('Back'),
                          ),
                          const SizedBox(width: 13),
                          ElevatedButton(
                            onPressed: () {
                              // Simply update the status to 'Closed' without asking for follow-up
                              updateStatus(
                                  widget.tindaklanjut['id'],
                                  'Closed',
                                  selectedTanggal,
                                  ''  // No follow-up details for Finish
                              );

                              // Navigate back to the TindakLanjutPageFE after finishing
                              Get.offAll(() => const TindakLanjutPageFE());
                            },
                            child: const Text('Finish'),
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
