import 'package:flutter/material.dart';
import 'package:fluttersip/FrontEndOnly/UserView/user_form_page_1_fe.dart';
import 'package:intl/intl.dart';


class UserFormPage0FE extends StatefulWidget {
  const UserFormPage0FE({super.key});

  @override
  _UserFormPage0FEState createState() => _UserFormPage0FEState();
}

class _UserFormPage0FEState extends State<UserFormPage0FE> {
  String? _selectedValue1; // For first question (radio list)

  final TextEditingController _textController1 = TextEditingController(); // For second question (text input)
  final TextEditingController _textController2 = TextEditingController();
  final TextEditingController _textController3 = TextEditingController();
  final TextEditingController _textController4 = TextEditingController();
  // Arrays for radio list options
  final List<String> options1 = [
    'Gedung Rektorat', 'Gedung Griya Legita',
    'Gedung LST (Laboratoria Sains dan Teknik)', 'Gedung GOR 1',
    'Gedung GOR 2', 'Kantin',
    'Lab Kontainer', 'Lingkungan Universitas Pertamina'];

  DateTime? _selectedDate;

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
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[700],
        title: const Text(
            'Tambah PEKA'
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blueGrey),
                  borderRadius: BorderRadius.circular(0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                     const Text.rich(
                      TextSpan(
                        text: 'Nama Pegawai',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold
                        ),children: <TextSpan>[
                        TextSpan(
                          text: ' *',
                          style: TextStyle(color: Colors.red, fontSize: 18),
                        ),
                      ]
                      ),
                    ),
                    const SizedBox(height: 16.0), // Space between title and input
                    TextField(
                      controller: _textController1,
                      decoration: const InputDecoration(
                        labelText: 'Enter text',
                      ),
                    ),
                    const SizedBox(height: 8.0),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blueGrey),
                  borderRadius: BorderRadius.circular(0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text.rich(
                      TextSpan(
                          text: 'Email Pekerja',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.bold
                          ),children: <TextSpan>[
                        TextSpan(
                          text: ' *',
                          style: TextStyle(color: Colors.red, fontSize: 18),
                        ),
                      ]
                      ),
                    ),
                    const SizedBox(height: 16.0), // Space between title and input
                    TextField(
                      controller: _textController3,
                      decoration: const InputDecoration(
                        labelText: 'Enter text',
                      ),
                    ),
                    const SizedBox(height: 8.0),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blueGrey),
                  borderRadius: BorderRadius.circular(0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text.rich(
                      TextSpan(
                          text: 'Nama Fungsi / Prodi',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.bold
                          ),children: <TextSpan>[
                        TextSpan(
                          text: ' *',
                          style: TextStyle(color: Colors.red, fontSize: 18),
                        ),
                      ]
                      ),
                    ),
                    const SizedBox(height: 16.0), // Space between title and input
                    TextField(
                      controller: _textController4,
                      decoration: const InputDecoration(
                        labelText: 'Enter text',
                      ),
                    ),
                    const SizedBox(height: 8.0),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Container(
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
                                  fontWeight: FontWeight.bold
                              ),children: <TextSpan>[
                            TextSpan(
                              text: ' *',
                              style: TextStyle(color: Colors.red, fontSize: 18),
                            ),
                          ]
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16.0), // Space between title and picker
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () => _selectDate(context),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 12.0, horizontal: 100.0),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.blueGrey),
                              borderRadius: BorderRadius.circular(0),
                              color: Colors.white,
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.calendar_today, color: Colors.blueGrey),
                                const SizedBox(width: 8.0), // Space between icon and text
                                Text(
                                  _selectedDate != null
                                      ? DateFormat('dd/MM/yyyy').format(_selectedDate!)
                                      : 'Pilih Tanggal',
                                  style: const TextStyle(
                                    fontSize: 16.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16.0),
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
                              fontWeight: FontWeight.bold
                          ),children: <TextSpan>[
                        TextSpan(
                          text: ' *',
                          style: TextStyle(color: Colors.red, fontSize: 18),
                        ),
                      ]
                      ),
                    ),
                    const SizedBox(height: 16.0), // Space between title and options
                    // Generate RadioListTile widgets dynamically from options1 array
                    ...options1.map((option) => RadioListTile<String>(
                      title: Text(option),
                      value: option,
                      groupValue: _selectedValue1,
                      onChanged: (value) {
                        setState(() {
                          _selectedValue1 = value;
                        });
                      },
                    )),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blueGrey),
                  borderRadius: BorderRadius.circular(0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text.rich(
                      TextSpan(
                          text: 'Lokasi Spesifik',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.bold
                          ),children: <TextSpan>[
                        TextSpan(
                          text: ' *',
                          style: TextStyle(color: Colors.red, fontSize: 18),
                        ),
                      ]
                      ),
                    ),
                    const SizedBox(height: 16.0), // Space between title and input
                    TextField(
                      controller: _textController2,
                      decoration: const InputDecoration(
                        labelText: 'Enter text',
                      ),
                    ),
                    const SizedBox(height: 8.0), // Space between TextField and subtext
                    const Text(
                      '(Lantai / Ruangan / Kelas, etc) ', // Subtext
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              //  Display selected values
              // Text('Selected Value for Question 1: ${_selectedValue1 ?? "None"}'),
              // Text('Input Text for Question 2: ${_textController2.text}'),
              // Text('Selected Value for Question 3: ${_selectedValue3 ?? "None"}'),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: (){
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const UserFormPage1FE())
                      );
                      },
                    child: const Text(
                    'Next',
                    style: TextStyle(
                        fontSize: 16
                    ),
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
}