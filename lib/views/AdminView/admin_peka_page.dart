import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttersip/views/UserView/user_form_page.dart';
import 'package:provider/provider.dart';
import 'package:fluttersip/views/service/global_service.dart';

class AdminPekaPage extends StatefulWidget {
  const AdminPekaPage({super.key});

  @override
  State<AdminPekaPage> createState() => _AdminPekaPageState();
}

class _AdminPekaPageState extends State<AdminPekaPage> {


  @override
  Widget build(BuildContext context) {
    final globalState = Provider.of<GlobalState>(context);
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('observations')
            .orderBy('timestamp',
            descending: false) // Order by timestamp ascending
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No observations found.'));
          }

          var documents = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: documents.length,
            itemBuilder: (context, index) {
              var doc = documents[index];
              var answers = List<Map<String, dynamic>>.from(doc['answers']);

              // Sort answers by questionId
              answers
                  .sort((a, b) => a['questionId'].compareTo(b['questionId']));

              return Container(
                padding: const EdgeInsets.all(16.0),
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blueGrey),
                  borderRadius: BorderRadius.circular(12.0),
                  color: Colors.white,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Timestamp: ${doc['timestamp']?.toDate().toString() ?? 'No timestamp'}',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[700],
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    // Use SingleChildScrollView to handle overflow
                    SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: answers.map((answer) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    'Pertanyaan  : ${answer['questionId']} - Answer: ${answer['answer']}',
                                    style: const TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed: () {
                                    _showEditDialog(context, doc.id,
                                        answer['questionId'], answer['answer']);
                                  },
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            _showDeleteConfirmation(context, doc.id);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FloatingActionButton.extended(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const UserFormPage1()),
              );
            },
            label: const Text('Tambah PEKA'),
            icon: const Icon(Icons.add),
            backgroundColor: Colors.red,
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.folder),
            label: 'PEKA',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: globalState.selectedIndex,
        onTap: (index) {
          globalState.onItemTapped(index, context);
        },
      ),
    );
  }

  void _showEditDialog(BuildContext context, String docId,
      String currentQuestionId, String currentAnswer) {
    final questionIdController =
    TextEditingController(text: currentQuestionId);
    final answerController = TextEditingController(text: currentAnswer);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Answer'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: questionIdController,
                decoration: const InputDecoration(labelText: 'Kategori'),
              ),
              TextField(
                controller: answerController,
                decoration: const InputDecoration(labelText: 'Answer'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _updateAnswer(
                    docId, questionIdController.text, answerController.text);
                Navigator.pop(context); // Close the dialog
              },
              child: const Text('Update'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _updateAnswer(
      String docId, String newQuestionId, String newAnswer) async {
    try {
      var doc = await FirebaseFirestore.instance
          .collection('observations')
          .doc(docId)
          .get();
      var answers = List<Map<String, dynamic>>.from(doc['answers']);

      // Find and update the specific answer
      var answerIndex =
      answers.indexWhere((answer) => answer['questionId'] == newQuestionId);
      if (answerIndex != -1) {
        answers[answerIndex]['answer'] = newAnswer;
        // Update the document with the new answers list
        await FirebaseFirestore.instance
            .collection('observations')
            .doc(docId)
            .update({
          'answers': answers,
          'timestamp':
          FieldValue.serverTimestamp(), // Optionally update the timestamp
        });
      } else {
        // If questionId does not exist, add new entry
        answers.add({
          'questionId': newQuestionId,
          'answer': newAnswer,
        });
        await FirebaseFirestore.instance
            .collection('observations')
            .doc(docId)
            .update({
          'answers': answers,
          'timestamp':
          FieldValue.serverTimestamp(), // Optionally update the timestamp
        });
      }
      // Optionally show a success message
    } catch (e) {
      print('Failed to update answer: $e');
      // Optionally show an error message
    }
  }

  void _showDeleteConfirmation(BuildContext context, String docId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Confirmation'),
          content: const Text('Are you sure you want to delete this observation?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _deleteObservation(docId);
                Navigator.pop(context); // Close the dialog
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteObservation(String docId) async {
    try {
      await FirebaseFirestore.instance
          .collection('observations')
          .doc(docId)
          .delete();
      // Optionally show a success message
    } catch (e) {
      print('Failed to delete observation: $e');
      // Optionally show an error message
    }
  }
}