// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:fluttersip/FrontEndOnly/UserView/user_form_page_2_fe.dart';
// import 'package:fluttersip/FrontEndOnly/UserView/user_peka_page_fe.dart';
//
//
//
//
// class UserFormUpdateFE extends StatefulWidget {
//   final Map<String, String?> selectedValues;
//   final String userId; // Add userId parameter
//
//   const UserFormUpdateFE({super.key, required this.selectedValues, required this.userId});
//
//   @override
//   _UserFormUpdateFEState createState() => _UserFormUpdateFEState();
// }
//
// class _UserFormUpdateFEState extends State<UserFormUpdateFE> {
//   late Map<String, String?> _combinedValues;
//
//   @override
//   void initState() {
//     super.initState();
//     _combinedValues = Map.from(widget.selectedValues);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('RadioListTile Screen'),
//       ),
//       body: UserFormPage2FE(
//         combinedValues: _combinedValues,
//         onSave: (updatedValues) {
//           _saveToFirestore(updatedValues);
//         },
//       ),
//     );
//   }
//
//   void _saveToFirestore(Map<String, String?> values) {
//     final firestore = FirebaseFirestore.instance;
//
//     var observations = values.entries.map((entry) {
//       return {
//         'questionId': entry.key,
//         'answer': entry.value,
//       };
//     }).toList();
//
//     firestore.collection('observations').add({
//       'userId': widget.userId, // Add userId to the document
//       'answers': observations,
//       'timestamp': FieldValue.serverTimestamp(), // Optional: add a timestamp
//     }).then((_) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('All answers stored successfully!')),
//       );
//       Navigator.pushAndRemoveUntil(
//         context,
//         MaterialPageRoute(builder: (context) => const UserPekaPageFE()),
//             (Route<dynamic> route) => false,
//       );
//     }).catchError((error) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Failed to store data: $error')),
//       );
//     });
//   }
// }
