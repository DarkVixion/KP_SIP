import 'package:flutter/material.dart';
import 'package:fluttersip/FrontEndOnly/UserView/user_form_page_1_fe.dart';





class UserFormPage0FE extends StatefulWidget {
  const UserFormPage0FE({super.key});

  @override
  _UserFormPage0FEState createState() => _UserFormPage0FEState();
}

class _UserFormPage0FEState extends State<UserFormPage0FE> {
  String? _selectedValue1; // For first question (radio list)

  final TextEditingController _textController2 = TextEditingController(); // For second question (text input)

  // Arrays for radio list options
  final List<String> options1 = [
    'Gedung Rektorat', 'Gedung Griya Legita',
    'Gedung LST (Laboratoria Sains dan Teknik)', 'Gedung GOR 1',
    'Gedung GOR 2', 'Kantin',
    'Lab Kontainer', 'Lingkungan Universitas Pertamina'];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[700],
        title: Text(
            'Tambah PEKA'
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // First Question - Radio List
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blueGrey),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'lokasi Observasi : ',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
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

              // Second Question - Text Input with Subtext
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blueGrey),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Lokasi Spesifik : ',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
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