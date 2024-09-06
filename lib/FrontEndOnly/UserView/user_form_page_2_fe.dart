
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttersip/FrontEndOnly/Service/global_service_fe.dart';
import 'package:fluttersip/FrontEndOnly/UserView/user_form_page_3_fe.dart';
import 'package:fluttersip/constants/constants.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class UserFormPage2FE extends StatefulWidget {
  const UserFormPage2FE({super.key});


  @override
  _UserFormPage2FEState createState() => _UserFormPage2FEState();
}

class _UserFormPage2FEState extends State<UserFormPage2FE> {


  @override
  void initState() {
    super.initState();
    fetchClsr().then((data) {
      setState(() {
        clsrOptions = data;
      });
    });
  }

  List<Map<String, dynamic>> clsrOptions = [];
  Future<List<Map<String, dynamic>>> fetchClsr() async {
    final response = await http.get(Uri.parse('${url}CLSR'));

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      List<Map<String, dynamic>> clsr = data.map((item) => {
        'id': item['id'].toString(),
        'nama': item['nama'],
        'deskripsi':item['deskripsi'],
      }).toList();
      return clsr;
    } else {
      throw Exception('Failed to load Lokasi Observasi');
    }
  }


  // Validation flags
  bool _tipeCLSRError = false;


  void _validateAndProceed() {
    final globalState = Provider.of<GlobalStateFE>(context, listen: false);
    setState(() {
      // Validate each field
      _tipeCLSRError = globalState.selectedClsrId == null;

    });

    // If all fields are valid, proceed to the next page
    if (!_tipeCLSRError) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const UserFormPage3FE()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final globalState = Provider.of<GlobalStateFE>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[700],
        title: const Center(
          child: Text(
            'Standard CLSR',
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
                  borderRadius: BorderRadius.circular(0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      '12 item Corporate Life Saving Rules',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16.0), // Space between title and options
                    Image.asset('images/CLSR.png'),
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
                          text: 'Pilih CLSR',
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
                    const Text(
                      'Pilihlah Kategori CLSR yang paling mewakili temuan Anda.'
                          '\n\nJika temuan anda tidak termasuk ke dalam kategori CLSR, silahkan pilih “Kategori Non-CLSR”.',
                      style: TextStyle(
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 16.0), // Space between title and options
                    // Generate RadioListTile widgets dynamically from options1 array
                    ...clsrOptions.map((option) => RadioListTile(
                      title: Text('${option['nama'] ?? 'Unknown'} - ${option['deskripsi'] ?? ''}'),
                      value: option['id'],
                      groupValue: globalState.selectedClsrId,
                      onChanged: (value) {
                        setState(() {
                          globalState.updateClsr(value!);
                          _tipeCLSRError = false;
                        });
                      },
                    )),
                    if (_tipeCLSRError)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          'Pilih CLSR wajib diisi.',
                          style: TextStyle(color: Colors.red.shade700),
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
            ],
          ),
        ),
      ),
    );
  }
}
