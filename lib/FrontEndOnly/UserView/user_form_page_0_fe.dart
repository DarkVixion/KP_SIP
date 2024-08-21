import 'package:flutter/material.dart';
import 'package:fluttersip/FrontEndOnly/UserView/user_form_page_1_fe.dart';
import 'package:intl/intl.dart';

class UserFormPage0FE extends StatefulWidget {
  const UserFormPage0FE({super.key});

  @override
  _UserFormPage0FEState createState() => _UserFormPage0FEState();
}

class _UserFormPage0FEState extends State<UserFormPage0FE> {
  String? _selectedValue1; // For location selection (radio list)
  final TextEditingController _textController1 = TextEditingController(); // For "Nama Pegawai"
  final TextEditingController _textController2 = TextEditingController(); // For "Lokasi Spesifik"
  final TextEditingController _textController3 = TextEditingController(); // For "Email Pekerja"
  final TextEditingController _textController4 = TextEditingController(); // For "Nama Fungsi / Prodi"
  DateTime? _selectedDate; // For date picker

  // Arrays for radio list options
  final List<String> options1 = [
    'Gedung Rektorat',
    'Gedung Griya Legita',
    'Gedung LST (Laboratoria Sains dan Teknik)',
    'Gedung GOR 1',
    'Gedung GOR 2',
    'Kantin',
    'Lab Kontainer',
    'Lingkungan Universitas Pertamina'
  ];

  // Validation flags
  bool _namaPegawaiError = false;
  bool _emailPekerjaError = false;
  bool _namaFungsiError = false;
  bool _lokasiObservasiError = false;
  bool _lokasiSpesifikError = false;
  bool _tanggalObservasiError = false;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
        _tanggalObservasiError = false;
      });
    }
  }

  void _validateAndProceed() {
    setState(() {
      // Validate each field
      _namaPegawaiError = _textController1.text.isEmpty;
      _emailPekerjaError = _textController3.text.isEmpty;
      _namaFungsiError = _textController4.text.isEmpty;
      _lokasiSpesifikError = _textController2.text.isEmpty;
      _lokasiObservasiError = _selectedValue1 == null;
      _tanggalObservasiError = _selectedDate == null;
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

  @override
  Widget build(BuildContext context) {
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
                controller: _textController1,
                errorMessage: 'Nama Pegawai wajib diisi.',
              ),
              const SizedBox(height: 20),
              // Email Pekerja
              _buildTextFieldContainer(
                label: 'Email Pekerja',
                isError: _emailPekerjaError,
                controller: _textController3,
                errorMessage: 'Email Pekerja wajib diisi.',
              ),
              const SizedBox(height: 20),
              // Nama Fungsi / Prodi
              _buildTextFieldContainer(
                label: 'Nama Fungsi / Prodi',
                isError: _namaFungsiError,
                controller: _textController4,
                errorMessage: 'Nama Fungsi / Prodi wajib diisi.',
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
                controller: _textController2,
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
            controller: controller,
            decoration: InputDecoration(
              labelText: hint ?? 'Enter text',
              errorText: isError ? errorMessage : null,
            ),
          ),
        ],
      ),
    );
  }

  // Widget for building date picker container with validation
  Widget _buildDatePickerContainer() {
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
                    _selectedDate != null
                        ? DateFormat('dd/MM/yyyy').format(_selectedDate!)
                        : 'Pilih Tanggal',
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
            children: options1.map((option) {
              return RadioListTile(
                title: Text(option),
                value: option,
                groupValue: _selectedValue1,
                onChanged: (value) {
                  setState(() {
                    _selectedValue1 = value;
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
