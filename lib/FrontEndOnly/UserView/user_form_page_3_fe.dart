import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

import 'package:fluttersip/FrontEndOnly/UserView/user_peka_page_fe.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: Scaffold(
        appBar: AppBar(title: const Text('RadioListTile Sample')),
        body: const UserFormPage3FE(),
      ),
    );
  }
}

class UserFormPage3FE extends StatefulWidget {
  const UserFormPage3FE({super.key});

  @override
  State<UserFormPage3FE> createState() => _UserFormPage3FEState();
}

class _UserFormPage3FEState extends State<UserFormPage3FE> {

  final TextEditingController _textController6 = TextEditingController(); // For second question (text input)
  final TextEditingController _textController7 = TextEditingController();
  final TextEditingController _textController8 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[700],
        title: const Center(
          child: Text(
            'Detail Of Obeservation',
          ),
        ),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
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
                      'Deskripsi Observasi / Observation Description : ',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16.0), // Space between title and input
                    TextField(
                      controller: _textController6,
                      decoration: const InputDecoration(
                        labelText: 'Enter text',
                      ),
                    ),
                    const SizedBox(height: 8.0), // Space between TextField and subtext
                    const Text(
                      'Contoh: Terdapat genangan air yang berorama tidak sedap ', // Subtext
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
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
                      'Direction Action (Tindakan Langsung) : ',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16.0), // Space between title and input
                    TextField(
                      controller: _textController7,
                      decoration: const InputDecoration(
                        labelText: 'Enter text',
                      ),
                    ),
                    const SizedBox(height: 8.0), // Space between TextField and subtext
                    const Text(
                      'Contoh: Menginformasikan kepada pihak terkait dan memberikan saran untuk segera dibersihkan/diperbaiki ', // Subtext
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20.0),
              Container(
                padding: const EdgeInsets.all(40.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blueGrey),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Bukti Gambar / Observasi',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16.0),
                    UploadOrCaptureImage(),
                    Text(
                      'Silahkan masukan bukti gambar temuan Anda (jika ada)',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20.0),
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
                      'Berikan saran anda untuk penggunaan Applikasi ini : ',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16.0), // Space between title and input
                    TextField(
                      controller: _textController8,
                      decoration: const InputDecoration(
                        labelText: 'Enter text',
                      ),
                    ),
                    const SizedBox(height: 8.0), // Space between TextField and subtext
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Column(
                    children: [
                      ElevatedButton(
                        onPressed: (){
                          Navigator.pop(context);
                        },
                        child: const Text(
                          'Back',
                          style: TextStyle(
                              fontSize: 16
                          ),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      ElevatedButton(
                        onPressed: (){
                          Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => UserPekaPageFE())
                          );
                        },
                        child: const Text(
                          'Submit ',
                          style: TextStyle(
                              fontSize: 16
                          ),
                        ),
                      ),
                    ],
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

class UploadOrCaptureImage extends StatefulWidget {
  const UploadOrCaptureImage({super.key});

  @override
  _UploadOrCaptureImageState createState() => _UploadOrCaptureImageState();
}

class _UploadOrCaptureImageState extends State<UploadOrCaptureImage> {
  File? _image;
  File? _file;



  Future<void> _uploadFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      setState(() {
        _file = File(result.files.single.path!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (_image != null) Image.file(_image!),
        if (_file != null) Text("Selected file: ${_file!.path.split('/').last}"),
        const SizedBox(height: 10),
        ElevatedButton.icon(
          onPressed: _uploadFile,
          icon: const Icon(Icons.upload_file),
          label: const Text("Upload File"),
        ),
      ],
    );
  }
}
