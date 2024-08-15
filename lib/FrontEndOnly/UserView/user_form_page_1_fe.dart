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

  String? _selectedValue4; // For first question (radio list)

  // Arrays for radio list options
  final List<String> options4 = [
    'Safe Action (Tindakan Aman) ','Safe Condition (Kondisi Aman) ',
    'Unsafe Action (Tindakan Tidak Aman) ','Unsafe Condition (Kondisi Tidak Aman) '
    ,'Nearmiss (Hampir Celaka) '];

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
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Tipe Observasi : ',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
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
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Kategory / Category',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
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
                              _selectedSecondCharacter = null; // Reset the second selection
                            });
                          },
                        ),
                      );
                    }),
                  ],
                ),
              ),
              const SizedBox(height: 16.0),
              if (_selectedFirstCharacter != null)
                Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.blueGrey),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Sub-Category $_selectedFirstCharacter',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
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
                              });
                            },
                          ),
                        );
                      }),
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
                        onPressed: (){
                          Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => UserFormPage2FE())
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
            ],
          ),
        ),
      ),
    );
  }
}