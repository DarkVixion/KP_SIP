import 'package:flutter/material.dart';
import 'package:fluttersip/FrontEndOnly/UserView/user_form_page_2_fe.dart';



class UserFormPage1FE extends StatefulWidget {
  const UserFormPage1FE({super.key});

  @override
  State<UserFormPage1FE> createState() => _UserFormPage1FEState();
}

class _UserFormPage1FEState extends State<UserFormPage1FE> {
  String? _selectedFirstCharacter;
  String? _selectedSecondCharacter;
  String? _selectedValue4; // For first question (radio list)

  // Arrays for radio list options
  final List<String> options4 = [
    'Safe Action (Tindakan Aman) ','Safe Condition (Kondisi Aman) ',
    'Unsafe Action (Tindakan Tidak Aman) ','Unsafe Condition (Kondisi Tidak Aman) '
    ,'Nearmiss (Hampir Celaka) '
  ];

  final List<String> firstOptions = [
    'Orang atau Pekerja',
    'Peralatan dan Perlengkapan Kerja',
    'Material / Bahan',
    'Pengendalian Administrasi',
    'Lingkungan Kerja'
  ];

  final Map<String, List<String>> secondOptions = {
    'Orang atau Pekerja': [ ' Metode Kerja ','Tahapan Kerja ',' Posisi Kerja ','Postur Kerja ','Alat Pelindung Diri (APD) ','Dan Lain-lain '],
    'Peralatan dan Perlengkapan Kerja': ['Ketersediaan Alat ',' Kesesuaian Fungsi Alat ','Kondisi Alat ','Penyimpanan / Penempatan Alat ',' Kondisi Pengaman / Tanda Bahaya ','Dan Lain-lain '],
    'Material / Bahan': ['Ketiadaan Material ','Informasi Material ','Penanganan Material ','Penyimpanan Material ',' Kesesuaian Material ','Material Pengganti (Substitusi) ','Dan Lain-lain '],
    'Pengendalian Administrasi': [' Izin Kerja ','Kajian Risiko ','Prosedur Operasional (POS) ','Sertifikasi / Inspeksi ','Isolasi Energi ','Rambu-rambu ','Serah Terima Pekerjaan ','Dan Lain-lain '],
    'Lingkungan Kerja': ['Kerapihan ','Kebersihan / Hygiene ','Akses ',' Keamanan Personal ',' Pengelolaan Limbah / Sampah ',' Bahan Berbahaya / Beracun (B3) ','Pencahayaan ',' Bahaya Binatang (Hewan liar, serangga, dll) ',' Ergonomi ',' Kebisingan ',' Dan Lain-lain '],
  };

  // Validation flags
  bool _tipeObservasiError = false;
  bool _kategoriError = false;
  bool _subKategoriError = false;

  void _validateAndProceed() {
    setState(() {
      // Validate each field
      _tipeObservasiError = _selectedValue4 == null;
      _kategoriError = _selectedFirstCharacter == null;
      _subKategoriError = _selectedFirstCharacter != null && _selectedSecondCharacter == null;
    });

    // If all fields are valid, proceed to the next page
    if (!_tipeObservasiError && !_kategoriError && !_subKategoriError) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const UserFormPage2FE()),
      );
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[700],
        title: const Center(
          child: Text(
              'OBSERVATION CLASSIFICATION',
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text.rich(
                      TextSpan(
                          text: 'Tipe Observasi',
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
                    ...options4.map((option) => RadioListTile<String>(
                      title: Text(option),
                      value: option,
                      groupValue: _selectedValue4,
                      onChanged: (value) {
                        setState(() {
                          _selectedValue4 = value;
                          _tipeObservasiError = false;
                        });
                      },
                    )),
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
                          text: 'Kategory / Category',
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
                    const SizedBox(height: 16.0),
                    ...firstOptions.map((option) {
                      return Material(
                        child: RadioListTile<String>(
                          title: Text(option),
                          value: option,
                          groupValue: _selectedFirstCharacter,
                          onChanged: (String? value) {
                            setState(() {
                              _selectedFirstCharacter = value;
                              _selectedSecondCharacter = null;// Reset the second selection
                              _kategoriError = false;
                              _subKategoriError = false;
                            });
                          },
                        ),
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
              if (_selectedFirstCharacter != null)
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
                            text: 'Sub-Category $_selectedFirstCharacter',
                            style: const TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.bold
                            ),children: const <TextSpan>[
                          TextSpan(
                            text: ' *',
                            style: TextStyle(color: Colors.red, fontSize: 18),
                          ),
                        ]
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      ...secondOptions[_selectedFirstCharacter]!.map((option) {
                        return Material(
                          child: RadioListTile<String>(
                            title: Text(option),
                            value: option,
                            groupValue: _selectedSecondCharacter,
                            onChanged: (String? value) {
                              setState(() {
                                _selectedSecondCharacter = value;
                                _subKategoriError = false;
                              });
                            },
                          ),
                        );
                      }),
                      if (_subKategoriError)
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            'Sub-Category wajib diisi.',
                            style: TextStyle(color: Colors.red.shade700),
                          ),
                        ),
                    ],
                  ),
                ),
              const SizedBox(height: 10),
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
