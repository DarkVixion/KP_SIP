import 'package:flutter/material.dart';
import 'package:fluttersip/FrontEndOnly/Service/global_service_fe.dart';
import 'dart:io';

import 'package:fluttersip/controllers/laporanpeka.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class UserFormPage3FE extends StatefulWidget {
  const UserFormPage3FE({super.key});

  @override
  State<UserFormPage3FE> createState() => _UserFormPage3FEState();
}

class _UserFormPage3FEState extends State<UserFormPage3FE> {

  final TextEditingController _deskripsiObservasi = TextEditingController(); // For second question (text input)
  final TextEditingController _directAction = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  File? _image;
  // Create an instance of the controller
  final LaporanPekaController _laporanPekaController = LaporanPekaController();

  bool _deskripsiObservasiError = false;
  bool _directActionError = false;

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
  }



  void _validateAndProceed() async {
    final globalState = Provider.of<GlobalStateFE>(context, listen: false);

    setState(() {
      // Validate each field
      _deskripsiObservasiError = globalState.deskripsiObservasi.isEmpty;
      _directActionError = globalState.directAction.isEmpty;

    });

    // If all fields are valid, proceed to the next page
    if (!_deskripsiObservasiError &&
        !_directActionError ) {
      try {
        if(globalState.selectedClsrId != '450') {
          if (_formKey.currentState!.validate()) {
            await _laporanPekaController.submitLaporan(
              namaPegawai: globalState.namaPegawai.trim(),
              emailPegawai: globalState.emailPekerja.trim(),
              namaFungsi: globalState.namaFungsi.trim(),
              lokasiSpesifik: globalState.lokasiSpesifik.trim(),
              deskripsiObservasi: globalState.deskripsiObservasi.trim(),
              directAction: globalState.directAction.trim(),
              tanggal: globalState.selectedTanggal!.toIso8601String(),
              userId: globalState.userId!.toString(),
              lokasiId: globalState.selectedLokasiId!.toString(),
              tipeobservasiId: globalState.selectedTipeObservasiId!.toString(),
              kategoriId: globalState.selectedSubKategoriId!.toString(),
              clsrId: globalState.selectedClsrId!.toString(),
              image: _image,
              nonClsr: 'No',
            );
          }
        }

        if(globalState.selectedClsrId == '450') {
          if (_formKey.currentState!.validate()) {
            await _laporanPekaController.submitLaporan(
              namaPegawai: globalState.namaPegawai.trim(),
              emailPegawai: globalState.emailPekerja.trim(),
              namaFungsi: globalState.namaFungsi.trim(),
              lokasiSpesifik: globalState.lokasiSpesifik.trim(),
              deskripsiObservasi: globalState.deskripsiObservasi.trim(),
              directAction: globalState.directAction.trim(),
              tanggal: globalState.selectedTanggal!.toIso8601String(),
              userId: globalState.userId!.toString(),
              lokasiId: globalState.selectedLokasiId!.toString(),
              tipeobservasiId: globalState.selectedTipeObservasiId!.toString(),
              kategoriId: globalState.selectedSubKategoriId!.toString(),
              clsrId: globalState.selectedClsrId!.toString(),
              image: _image,
              nonClsr: globalState.selectedNonClsr.toString(),
            );
          }
        }

        // On successful submission, show a success message or navigate to another screen
        ScaffoldMessenger.of(context).showSnackBar(
           const SnackBar(content: Text("Submission Successful ")),
        );

      } catch (error) {
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
          child: Form(
            key: _formKey,
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Bukti Gambar / Observasi',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _image == null
                              ? TextButton(
                            onPressed: _pickImage,
                            child: const Text('Pick an image'),
                          )
                              : Image.file(_image!, height: 100),
                        ],
                      ),
                      const Text(
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
      ),
    );
  }
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });

      // Save the picked image in GlobalStateFE
      Provider.of<GlobalStateFE>(context, listen: false).updateImage(_image);
    }
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
            hintText: hint ?? 'Enter text',
            hintMaxLines: 3,  // Allows hint text to span multiple lines
            isDense: true,  // Reduces the default vertical space
            contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 12.0), // Adjusts the padding inside the TextField
            errorText: isError ? errorMessage : null,

          ),
        ),
      ],
    ),
  );
}


