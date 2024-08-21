import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class Test extends StatefulWidget {
  const Test({super.key});

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
  String? _selectedRadioValue;
  DateTime? _selectedDate;
  bool _radioValidationError = false;
  bool _dateValidationError = false;

  // Function to validate if all required fields are filled
  bool _validateFields() {
    setState(() {
      _radioValidationError = _selectedRadioValue == null;
      _dateValidationError = _selectedDate == null;
    });
    return !_radioValidationError && !_dateValidationError;
  }

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
        _dateValidationError = false; // Reset error when date is picked
      });
    }
  }

  void _moveToNextPage() {
    if (_validateFields()) {
      // Navigate to the next page if validation passes
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const NextPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Required Fields Example')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Question 1 - Radio List
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
                    'Tipe Observasi',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  RadioListTile<String>(
                    title: const Text('Orang atau Pekerja'),
                    value: 'Orang atau Pekerja',
                    groupValue: _selectedRadioValue,
                    onChanged: (value) {
                      setState(() {
                        _selectedRadioValue = value;
                        _radioValidationError = false; // Reset error when a radio option is selected
                      });
                    },
                  ),
                  RadioListTile<String>(
                    title: const Text('Peralatan dan Perlengkapan Kerja'),
                    value: 'Peralatan dan Perlengkapan Kerja',
                    groupValue: _selectedRadioValue,
                    onChanged: (value) {
                      setState(() {
                        _selectedRadioValue = value;
                        _radioValidationError = false;
                      });
                    },
                  ),
                  if (_radioValidationError)
                    Container(
                      margin: const EdgeInsets.only(top: 8.0),
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.red),
                        borderRadius: BorderRadius.circular(8.0),
                        color: Colors.red.shade50,
                      ),
                      child: const Text(
                        'Silakan pilih tipe observasi.',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 16.0),

            // Question 2 - Date Picker
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
                    'Tanggal Observasi',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  InkWell(
                    onTap: () => _selectDate(context),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 12.0, horizontal: 16.0),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.blueGrey),
                        borderRadius: BorderRadius.circular(12.0),
                        color: Colors.white,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.calendar_today, color: Colors.blueGrey),
                              const SizedBox(width: 8.0),
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
                          const Icon(Icons.arrow_drop_down, color: Colors.blueGrey),
                        ],
                      ),
                    ),
                  ),
                  if (_dateValidationError)
                    Container(
                      margin: const EdgeInsets.only(top: 8.0),
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.red),
                        borderRadius: BorderRadius.circular(8.0),
                        color: Colors.red.shade50,
                      ),
                      child: const Text(
                        'Silakan pilih tanggal observasi.',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 16.0),

            const Spacer(),

            // Next Button
            ElevatedButton(
              onPressed: _moveToNextPage,
              child: const Text('Lanjutkan'),
            ),
          ],
        ),
      ),
    );
  }
}

class NextPage extends StatelessWidget {
  const NextPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Next Page')),
      body: const Center(child: Text('This is the next page!')),
    );
  }
}
