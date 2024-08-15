
import 'package:flutter/material.dart';
import 'package:fluttersip/FrontEndOnly/UserView/user_form_page_3_fe.dart';

class UserFormPage2FE extends StatefulWidget {
  const UserFormPage2FE({super.key});


  @override
  _UserFormPage2FEState createState() => _UserFormPage2FEState();
}

class _UserFormPage2FEState extends State<UserFormPage2FE> {


  String? _selectedValue5; // For first question (radio list)

  // Arrays for radio list options
  final List<String> options5 = [
    'Kategori Non-CLSR','CLSR Elemen 1 - Tools and Equipment (Peralatan dan Perlengkapan)',
    'CLSR Elemen 2 - Safe Zone Position (Posisi Zona Aman)','CLSR Elemen 3 - Permit to Work (Ijin Kerja)',
    'CLSR Elemen 4 - Energy Isolation (Isolasi Energi)','CLSR Elemen 5 - Confined Space (Ruang Terbatas)',
    'CLSR Elemen 6 - Lifting Operation (Operasi Pengangkatan)','CLSR Elemen 7 - Fit to Work (Fit untuk Bekerja)',
    'CLSR Elemen 8 - Working at Height (Bekerja di Ketinggian)','CLSR Elemen 9 - Personal Floatation Device (Perangkat Apung Pribadi)',
    'CLSR Elemen 10 - System Override (Peralatan keselamatan kritikal harus berfungsi dengan baik untuk menjaga keselamatan anda.)','CLSR Elemen 11 - Asset Integrity (Integritas Aset)',
    'CLSR Elemen 12 - Driving Safety (Keselamatan Berkendara)'];

  @override
  Widget build(BuildContext context) {
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
                    ...options5.map((option) => RadioListTile<String>(
                      title: Text(option),
                      value: option,
                      groupValue: _selectedValue5,
                      onChanged: (value) {
                        setState(() {
                          _selectedValue5 = value;
                        });
                      },
                    )),
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
                        MaterialPageRoute(builder: (context) => UserFormPage3FE())
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
