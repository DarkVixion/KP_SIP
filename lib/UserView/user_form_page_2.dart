import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserFormPage2 extends StatefulWidget {
  final Map<String, String?> combinedValues;
  final Function(Map<String, String?>) onSave;

  const UserFormPage2({
    super.key,
    required this.combinedValues,
    required this.onSave,
  });

  @override
  _UserFormPage2State createState() => _UserFormPage2State();
}

class _UserFormPage2State extends State<UserFormPage2> {
  String? _selectedFirstCharacter;
  String? _selectedSecondCharacter;

  List<String> firstOptions = [];
  Map<String, List<String>> secondOptions = {};

  @override
  void initState() {
    super.initState();
    fetchDataFromFirestore();
  }

  Future<void> fetchDataFromFirestore() async {
    CollectionReference questions = FirebaseFirestore.instance.collection('Category');

    // Fetching first options
    QuerySnapshot querySnapshot = await questions.get();
    List<QueryDocumentSnapshot> docs = querySnapshot.docs;

    // Parsing data
    for (var doc in docs) {
      String question = doc['question'];
      List<String> options = List<String>.from(doc['options']);
      firstOptions.add(question);
      secondOptions[question] = options;
    }

    setState(() {});
  }

  void _saveSelection() {
    if (_selectedFirstCharacter != null && _selectedSecondCharacter != null) {
      widget.combinedValues['selectedFirstCharacter'] = _selectedFirstCharacter;
      widget.combinedValues['selectedSecondCharacter'] = _selectedSecondCharacter;
      widget.onSave(widget.combinedValues);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
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
                  'Kategori :',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16.0),
                Column(
                  children: firstOptions.map((option) {
                    return RadioListTile<String>(
                      title: Text(option),
                      value: option,
                      groupValue: _selectedFirstCharacter,
                      onChanged: (value) {
                        setState(() {
                          _selectedFirstCharacter = value;
                          _selectedSecondCharacter = null; // Reset second character
                        });
                      },
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16.0),
          if (_selectedFirstCharacter != null && secondOptions[_selectedFirstCharacter!] != null)
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blueGrey),
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Column(
                children: secondOptions[_selectedFirstCharacter!]!.map((option) {
                  return RadioListTile<String>(
                    title: Text(option),
                    value: option,
                    groupValue: _selectedSecondCharacter,
                    onChanged: (value) {
                      setState(() {
                        _selectedSecondCharacter = value;
                      });
                    },
                  );
                }).toList(),
              ),
            ),
          const SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: _saveSelection,
            child: const Text('Save All Selections'),
          ),
        ],
      ),
    );
  }
}
