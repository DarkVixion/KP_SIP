import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttersip/views/UserView/user_form_page_2.dart';
import 'package:fluttersip/views/UserView/user_peka_page.dart';



class UserFormUpdate extends StatefulWidget {
  final Map<String, String?> selectedValues;
  final String userId; // Add userId parameter

  const UserFormUpdate({super.key, required this.selectedValues, required this.userId});

  @override
  _UserFormUpdateState createState() => _UserFormUpdateState();
}

class _UserFormUpdateState extends State<UserFormUpdate> {
  late Map<String, String?> _combinedValues;

  @override
  void initState() {
    super.initState();
    _combinedValues = Map.from(widget.selectedValues);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('RadioListTile Screen'),
      ),
      body: UserFormPage2(
        combinedValues: _combinedValues,
        onSave: (updatedValues) {
          _saveToFirestore(updatedValues);
        },
      ),
    );
  }

  void _saveToFirestore(Map<String, String?> values) {
    final firestore = FirebaseFirestore.instance;

    var observations = values.entries.map((entri) {
      return {
        'questionId': entri.key,
        'answer': entri.value,
      };
    }).toList();

    firestore.collection('observations').add({
      'userId': widget.userId, // Add userId to the document
      'answers': observations,
      'timestamp': FieldValue.serverTimestamp(), // Optional: add a timestamp
    }).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('All answers stored successfully!')),
      );
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const UserPekaPage()),
            (Route<dynamic> route) => false,
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to store data: $error')),
      );
    });
  }
}
