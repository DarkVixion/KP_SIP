import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:fluttersip/FrontEndOnly/Service/global_service_fe.dart';
import 'dart:io';

import 'package:fluttersip/controllers/laporanpeka.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class UserFormPage3FE extends StatefulWidget {
  const UserFormPage3FE({super.key});

  @override
  State<UserFormPage3FE> createState() => _UserFormPage3FEState();
}

class _UserFormPage3FEState extends State<UserFormPage3FE> {

  final TextEditingController _deskripsiObservasi = TextEditingController(); // For second question (text input)
  final TextEditingController _directAction = TextEditingController();
  final TextEditingController _saranAplikasi = TextEditingController();
  final LaporanPekaController _laporanPekaController = Get.put(LaporanPekaController());




  bool _deskripsiObservasiError = false;
  bool _directActionError = false;
  bool _saranAplikasiError = false;

  @override
  void initState() {
    super.initState();
    _deskripsiObservasi.addListener(() {
      Provider.of<GlobalStateFE>(context, listen: false)
          .updatedeskripsiObservasi(_deskripsiObservasi.text);
    });
    _directAction.addListener(() {
      Provider.of<GlobalStateFE>(context, listen: false)
          .updatedirectAction(_directAction.text);
    });
    _saranAplikasi.addListener(() {
      Provider.of<GlobalStateFE>(context, listen: false)
          .updatesaranAplikasi(_saranAplikasi.text);
    });
  }

  void _validateAndProceed() {
    final globalState = Provider.of<GlobalStateFE>(context, listen: false);

    setState(() {
      // Validate each field
      _deskripsiObservasiError = globalState.deskripsiObservasi.isEmpty;
      _directActionError = globalState.directAction.isEmpty;
      _saranAplikasiError = globalState.saranAplikasi.isEmpty;

    });

    // If all fields are valid, proceed to the next page
    if (!_deskripsiObservasiError &&
        !_directActionError &&
        !_saranAplikasiError) {
      try {
        _laporanPekaController.submit(
          namaPegawai: globalState.namaPegawai.toString().trim(),
          emailPegawai: globalState.emailPekerja.toString().trim(),
          namaFungsi: globalState.namaFungsi.toString().trim(),
          lokasiSpesifik: globalState.lokasiSpesifik.toString().trim(),
          deskripsiObservasi: globalState.deskripsiObservasi.toString().trim(),
          directAction: globalState.directAction.toString().trim(),
          saranAplikasi: globalState.saranAplikasi.toString().trim(),
          tanggal: globalState.selectedTanggal!.toIso8601String().trim(),
          userId: globalState.userId!.toString(),
          lokasiId: globalState.selectedLokasiId!.toString(),
          tipeobservasiId: globalState.selectedTipeObservasiId!.toString(),
          kategoriId: globalState.selectedSubKategoriId!.toString(),
          clsrId: globalState.selectedClsrId!.toString(),
        );

        // On successful submission, show a success message or navigate to another screen
        ScaffoldMessenger.of(context).showSnackBar(
           SnackBar(content: Text("Submission Successful ")),
        );
        print(globalState.userId);
        print(globalState.namaPegawai);
        print(globalState.emailPekerja);
        print(globalState.namaFungsi);
        print(globalState.selectedTanggal);
        print(globalState.selectedLokasiId);
        print(globalState.lokasiSpesifik);
        print(globalState.selectedTipeObservasiId);
        print(globalState.selectedSubKategoriId);
        print(globalState.selectedClsrId);
        print(globalState.deskripsiObservasi);
        print(globalState.directAction);
        print(globalState.saranAplikasi);
      } catch (error) {
        // If an error occurs during submission, show an error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: ${error.toString()}")),
        );
      }
    }
  }

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
              _buildTextFieldContainer(
                label: 'Deskripsi Observasi / Observation Description',
                isError: _deskripsiObservasiError,
                controller: _deskripsiObservasi,
                errorMessage: 'Deskripsi Observasi wajib diisi.',
                hint: 'Contoh: Terdapat genangan air yang berorama tidak sedap',
              ),
              const SizedBox(height: 20.0),
              _buildTextFieldContainer(
                label: 'Direct Action (Tindakan Langsung)',
                isError: _directActionError,
                controller: _directAction,
                errorMessage: 'Direct Action wajib diisi.',
                hint: 'Contoh: Menginformasikan kepada pihak terkait dan memberikan saran untuk segera dibersihkan/diperbaiki ',
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blueGrey),
                  borderRadius: BorderRadius.circular(0),
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
                    SizedBox(height: 8.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        UploadOrCaptureImage(),
                      ],
                    ),
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
              const SizedBox(height: 20),
              _buildTextFieldContainer(
                label: 'Berikan saran anda untuk penggunaan Aplikasi ini',
                isError: _saranAplikasiError,
                controller: _saranAplikasi,
                errorMessage: 'Saran Aplikasi wajib diisi.',
              ),
              const SizedBox(height: 20.0),
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
                        onPressed: _validateAndProceed,
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
      mainAxisAlignment: MainAxisAlignment.center,
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
