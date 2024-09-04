import 'package:flutter/material.dart';
import 'package:fluttersip/constants/constants.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fluttersip/FrontEndOnly/Service/global_service_fe.dart';
import 'package:fluttersip/FrontEndOnly/UserView/user_form_page_2_fe.dart';

class UserFormPage1FE extends StatefulWidget {
  const UserFormPage1FE({super.key});

  @override
  State<UserFormPage1FE> createState() => _UserFormPage1FEState();
}

class _UserFormPage1FEState extends State<UserFormPage1FE> {




  bool _tipeObservasiError = false;
  bool _kategoriError = false;
  bool _subKategoriError = false;


  List<Map<String, dynamic>> tipeObservasiOptions = [];
  Future<List<Map<String, dynamic>>> fetchTipeObservasis() async {
    final response = await http.get(Uri.parse('${url}TipeObservasi'));

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      List<Map<String, dynamic>> tipeObservasi = data.map((item) => {
        'id': item['id'],
        'nama': item['nama'],
      }).toList();
      return tipeObservasi;
    } else {
      throw Exception('Failed to load Lokasi Observasi');
    }
  }
  @override
  void initState() {
    super.initState();
    _fetchCategories();
    fetchTipeObservasis().then((data) {
      setState(() {
        tipeObservasiOptions = data;
      });
    });
  }

  List<Map<String, dynamic>> _firstOptions = [];
  Map<String, List<Map<String, dynamic>>> _secondOptions = {};
  Future<void> _fetchCategories() async {
    final response = await http.get(Uri.parse('${url}Kategori'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      final List<Map<String, dynamic>> firstOptions = [];
      final Map<String, List<Map<String, dynamic>>> secondOptions = {};

      for (var item in data) {
        final category = item as Map<String, dynamic>;
        if (category['kategori_id'] == null) {
          firstOptions.add({
            'id': category['id'],
            'nama': category['nama'],
          });
        } else {
          final parentCategory = data.firstWhere((cat) => cat['id'] == category['kategori_id']);
          final parentCategoryName = parentCategory['nama'];

          if (!secondOptions.containsKey(parentCategoryName)) {
            secondOptions[parentCategoryName] = [];
          }
          secondOptions[parentCategoryName]!.add({
            'id': category['id'],
            'nama': category['nama'],
          });
        }
      }

      setState(() {
        _firstOptions = firstOptions;
        _secondOptions = secondOptions;
      });
    }
  }

  void _validateAndProceed() {
    final globalState = Provider.of<GlobalStateFE>(context, listen: false);

    setState(() {
      _tipeObservasiError = globalState.selectedTipeObservasiId == null;
      _kategoriError = globalState.selectedKategori == null;
      _subKategoriError = globalState.selectedSubKategoriId == null;
    });

    if (!_tipeObservasiError && !_kategoriError && !_subKategoriError) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const UserFormPage2FE(),
        ),
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
          child: Text('OBSERVATION CLASSIFICATION'),
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text.rich(
                      TextSpan(
                        text: 'Tipe Observasi',
                        style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
                        children: <TextSpan>[
                          TextSpan(text: ' *', style: TextStyle(color: Colors.red, fontSize: 18)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    ...tipeObservasiOptions.map((option) {
                      return RadioListTile(
                        title: Text(option['nama']),
                        value: option['id'],
                        groupValue: globalState.selectedTipeObservasiId,
                        onChanged: (value) {
                          setState(() {
                            globalState.updateTipeObservasi(value!);
                            _tipeObservasiError = false;
                          });
                        },
                      );
                    }),
                    if (_tipeObservasiError)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          'Tipe Observasi wajib diisi.',
                          style: TextStyle(color: Colors.red.shade700),
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
                  borderRadius: BorderRadius.circular(0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text.rich(
                      TextSpan(
                        text: 'Kategori / Category',
                        style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
                        children: <TextSpan>[
                          TextSpan(text: ' *', style: TextStyle(color: Colors.red, fontSize: 18)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    ..._firstOptions.map((option) {
                      return RadioListTile(
                        title: Text(option['nama']),
                        value: option['nama'],
                        groupValue: globalState.selectedKategori,
                        onChanged: (value) {
                          setState(() {
                            globalState.updateKategori(value!);
                            _kategoriError = false;
                            // Reset Sub-Kategori if Kategori changes
                            globalState.updateSubKategori(null);
                          });
                        },
                      );
                    }),
                    if (_kategoriError)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          'Kategori wajib diisi.',
                          style: TextStyle(color: Colors.red.shade700),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 16.0),
              if (globalState.selectedKategori != null)
                Container(
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
                          text: 'Sub-Category ${globalState.selectedKategori}',
                          style: const TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
                          children: const <TextSpan>[
                            TextSpan(text: ' *', style: TextStyle(color: Colors.red, fontSize: 18)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      ...(_secondOptions[globalState.selectedKategori] ?? []).map((option) {
                        return RadioListTile<int>(
                          title: Text(option['nama']),
                          value: option['id'],
                          groupValue: globalState.selectedSubKategoriId,
                          onChanged: (value) {
                            setState(() {
                              globalState.updateSubKategori(value!);
                              _subKategoriError = false;
                            });
                          },
                        );
                      }),
                      if (_subKategoriError)
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            'Sub Kategori wajib diisi.',
                            style: TextStyle(color: Colors.red.shade700),
                          ),
                        ),
                    ],
                  ),
                ),
              const SizedBox(height: 32.0),
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
                          ),),
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
