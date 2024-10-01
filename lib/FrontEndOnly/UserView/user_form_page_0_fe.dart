import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttersip/FrontEndOnly/Service/global_service_fe.dart';
import 'package:fluttersip/FrontEndOnly/UserView/user_form_page_1_fe.dart';
import 'package:fluttersip/constants/constants.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class UserFormPage0FE extends StatefulWidget {
  const UserFormPage0FE({super.key});

  @override
  _UserFormPage0FEState createState() => _UserFormPage0FEState();
}

class _UserFormPage0FEState extends State<UserFormPage0FE> {
  final TextEditingController _namaPegawaiController = TextEditingController();
  final TextEditingController _emailPekerjaController = TextEditingController();
  final TextEditingController _namaFungsiController = TextEditingController();
  final TextEditingController _lokasiSpesifikController = TextEditingController();



  List<Map<String, dynamic>> lokasiOptions = [];

  Future<List<Map<String, dynamic>>> fetchLokasi() async {
    final response = await http.get(Uri.parse('${url}Lokasi'));

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      List<Map<String, dynamic>> lokasiObservasi = data.map((item) => {
        'id': item['id'].toString(),
        'nama': item['nama'],
      }).toList();
      return lokasiObservasi;
    } else {
      throw Exception('Failed to load Lokasi Observasi');
    }
  }
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Fetch values from GetStorage
      var userName = box.read('userName');
      var userEmail = box.read('userEmail');
      var userFungsiD = box.read('userFungsiD');

      // Update the controllers without calling setState()
      _namaPegawaiController.text = userName;
      _emailPekerjaController.text = userEmail;
      _namaFungsiController.text = userFungsiD;

      // Update the GlobalStateFE with the initial values without setState()
      final globalState = Provider.of<GlobalStateFE>(context, listen: false);
      globalState.updateNamaPegawai(userName);
      globalState.updateEmailPekerja(userEmail);
      globalState.updateNamaFungsi(userFungsiD);

      // Set the default date to today if no date has been selected
      if (globalState.selectedTanggal == null) {
        globalState.selectedTanggal = DateTime.now();
      }

      // Fetch Lokasi without calling setState in the callback
      fetchLokasi().then((data) {
        setState(() {
          lokasiOptions = data;
        });
      });

      // Add listeners to update the global state when text fields change
      _namaPegawaiController.addListener(() {
        globalState.updateNamaPegawai(_namaPegawaiController.text);
      });
      _emailPekerjaController.addListener(() {
        globalState.updateEmailPekerja(_emailPekerjaController.text);
      });
      _namaFungsiController.addListener(() {
        globalState.updateNamaFungsi(_namaFungsiController.text);
      });
      _lokasiSpesifikController.addListener(() {
        globalState.updateLokasiSpesifik(_lokasiSpesifikController.text);
      });
    });
  }


  bool _namaPegawaiError = false;
  bool _emailPekerjaError = false;
  bool _namaFungsiError = false;
  bool _lokasiObservasiError = false;
  bool _lokasiSpesifikError = false;
  bool _tanggalObservasiError = false;

  Future<void> _selectDate(BuildContext context) async {
    final globalState = Provider.of<GlobalStateFE>(context, listen: false);
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: globalState.selectedTanggal ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null && pickedDate != globalState.selectedTanggal) {
      setState(() {
        globalState.selectedTanggal = pickedDate;
        _tanggalObservasiError = false;
      });
    }
  }

  void _validateAndProceed() {
    final globalState = Provider.of<GlobalStateFE>(context, listen: false);
    setState(() {
      // Validate each field
      _namaPegawaiError =  globalState.namaPegawai.isEmpty;
      _emailPekerjaError =  globalState.emailPekerja.isEmpty;
      _namaFungsiError =  globalState.namaFungsi.isEmpty;
      _lokasiSpesifikError =  globalState.lokasiSpesifik.isEmpty;
      _lokasiObservasiError =  globalState.selectedLokasiId == '';
      _tanggalObservasiError = globalState.selectedTanggal == null;
    });

    // If all fields are valid, proceed to the next page
    if (!_namaPegawaiError &&
        !_emailPekerjaError &&
        !_namaFungsiError &&
        !_lokasiSpesifikError &&
        !_lokasiObservasiError &&
        !_tanggalObservasiError) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const UserFormPage1FE()),
      );
    }
  }

  final box = GetStorage();

  @override
  Widget build(BuildContext context) {
    Provider.of<GlobalStateFE>(context);


    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[700],
        title: const Text('Tambah PEKA'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Nama Pegawai
              _buildTextFieldContainer(
                label: 'Nama Pegawai',
                isError: _namaPegawaiError,
                controller: _namaPegawaiController,
                errorMessage: 'Nama Pegawai wajib diisi.',
                active: false,
              ),
              const SizedBox(height: 20),
              // Email Pekerja
              _buildTextFieldContainer(
                label: 'Email Pekerja',
                isError: _emailPekerjaError,
                controller: _emailPekerjaController,
                errorMessage: 'Email Pekerja wajib diisi.',
                active: false,
              ),
              const SizedBox(height: 20),
              // Nama Fungsi / Prodi
              _buildTextFieldContainer(
                label: 'Nama Fungsi / Prodi',
                isError: _namaFungsiError,
                controller: _namaFungsiController,
                errorMessage: 'Nama Fungsi / Prodi wajib diisi.',
                active: false,
              ),
              const SizedBox(height: 20),
              // Tanggal Observasi
              _buildDatePickerContainer(),
              const SizedBox(height: 20),
              // Lokasi Observasi
              _buildRadioListContainer(),
              const SizedBox(height: 20),
              // Lokasi Spesifik
              _buildTextFieldContainer(
                label: 'Lokasi Spesifik',
                isError: _lokasiSpesifikError,
                controller: _lokasiSpesifikController,
                errorMessage: 'Lokasi Spesifik wajib diisi.',
                hint: '(Lantai / Ruangan / Kelas, etc)',
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: _validateAndProceed,
                    child: const Text(
                      'Next',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget for building text field containers with validation
  Widget _buildTextFieldContainer({
    required String label,
    required bool isError,
    required TextEditingController controller,
    required String errorMessage,
    String? hint,
    bool? active,
  }) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blueGrey),
        borderRadius: BorderRadius.circular(0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text.rich(
            TextSpan(
              text: label,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              children: const [
                TextSpan(
                  text: ' *',
                  style: TextStyle(color: Colors.red, fontSize: 18),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16.0),
          TextField(
            enabled: active ?? true,
            controller: controller,
            decoration: InputDecoration(
              labelText: hint,
              errorText: isError ? errorMessage : null,
            ),
          ),
        ],
      ),
    );
  }

  // Widget for building date picker container with validation
  // Widget for building date picker container with validation
  Widget _buildDatePickerContainer() {
    final globalState = Provider.of<GlobalStateFE>(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blueGrey),
        borderRadius: BorderRadius.circular(0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Text.rich(
                TextSpan(
                  text: 'Tanggal Observasi',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  children: [
                    TextSpan(
                      text: ' *',
                      style: TextStyle(color: Colors.red, fontSize: 18),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16.0),
          InkWell(
            onTap: () => _selectDate(context),
            child: Container(
              padding: const EdgeInsets.symmetric(
                vertical: 12.0,
                horizontal: 16.0,
              ),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blueGrey),
                borderRadius: BorderRadius.circular(0),
                color: Colors.white,
              ),
              child: Row(
                children: [
                  const Icon(Icons.calendar_today, color: Colors.blueGrey),
                  const SizedBox(width: 8.0),
                  Text(
                    // If no date is selected, use today's date as default
                    DateFormat('dd/MM/yyyy').format(globalState.selectedTanggal ?? DateTime.now()),
                    style: const TextStyle(fontSize: 16.0),
                  ),
                ],
              ),
            ),
          ),
          if (_tanggalObservasiError)
            Container(
              margin: const EdgeInsets.only(top: 8.0),
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.red),
                borderRadius: BorderRadius.circular(8.0),
                color: Colors.red.shade50,
              ),
              child: const Text(
                'Tanggal Observasi wajib diisi.',
                style: TextStyle(color: Colors.red),
              ),
            ),
        ],
      ),
    );
  }


  // Widget for building radio list container with validation
  Widget _buildRadioListContainer() {
    final globalState = Provider.of<GlobalStateFE>(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blueGrey),
        borderRadius: BorderRadius.circular(0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text.rich(
            TextSpan(
              text: 'Lokasi Observasi',
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              children: [
                TextSpan(
                  text: ' *',
                  style: TextStyle(color: Colors.red, fontSize: 18),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16.0),
          Column(
            children: lokasiOptions.map((option) {
              return RadioListTile(
                title: Text(option['nama']),
                value: option['id'],
                groupValue: globalState.selectedLokasiId,
                onChanged: (value) {
                  setState(() {
                    globalState.updateLokasiObservasi(value!);
                    _lokasiObservasiError = false;
                  });
                },
              );
            }).toList(),
          ),
          if (_lokasiObservasiError)
            Container(
              margin: const EdgeInsets.only(top: 8.0),
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.red),
                borderRadius: BorderRadius.circular(8.0),
                color: Colors.red.shade50,
              ),
              child: const Text(
                'Lokasi Observasi wajib diisi.',
                style: TextStyle(color: Colors.red),
              ),
            ),
        ],
      ),
    );
  }
}
