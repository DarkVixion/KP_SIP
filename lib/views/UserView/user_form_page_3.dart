// import 'package:flutter/material.dart';
//
// class UserFormPage3 extends StatefulWidget {
//   const UserFormPage3({super.key});
//
//   @override
//   State<UserFormPage3> createState() => _UserFormPage3State();
// }
//
// class _UserFormPage3State extends State<UserFormPage3> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//
//       Column(
//         mainAxisAlignment: MainAxisAlignment.start,
//         children: filteredAnswers.map((answer) {
//           return Padding(
//             padding: const EdgeInsets.symmetric(vertical: 4.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 if (answer['imageUrl'] != null && answer['imageUrl'].isNotEmpty) // Check if image URL exists
//                   Padding(
//                     padding: const EdgeInsets.only(bottom: 8.0),
//                     child: Image.network(
//                       answer['imageUrl'],
//                       height: 100, // Adjust size as needed
//                       width: double.infinity,
//                       fit: BoxFit.cover,
//                     ),
//                   ),
//                 Text(
//                   '${answer['answer']}',
//                   style: const TextStyle(
//                     fontSize: 16,
//                   ),
//                 ),
//               ],
//             ),
//           );
//         }).toList(),
//       ),
//       const SizedBox(height: 8.0),
//       // Display timestamp
//       Column(
//         mainAxisAlignment: MainAxisAlignment.end,
//         children: [
//           Text(
//             '${doc['timestamp']?.toDate().toString() ?? 'No timestamp'}',
//             style: TextStyle(
//               fontSize: 16,
//               color: Colors.grey[700],
//             ),
//           ),
//         ],
//       ),
//       ],
//     ),
//
//   }
// }
//
//
