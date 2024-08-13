import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttersip/UserView/user_home_page.dart';
import 'package:fluttersip/UserView/user_form_page.dart';
import 'package:fluttersip/profile_page.dart';

class UserPekaPage extends StatefulWidget {
  const UserPekaPage({super.key});

  @override
  State<UserPekaPage> createState() => _UserPekaPageState();
}

class _UserPekaPageState extends State<UserPekaPage> {
  int _selectedIndex = 0;
  final String? userId = FirebaseAuth.instance.currentUser?.uid;
  final String targetQuestionId = "Tipe Observasi"; // The question ID to filter by

  @override
  void initState() {
    super.initState();
  }

  Future<String?> _getImageUrl(String imagePath) async {
    try {
      final ref = FirebaseStorage.instance.ref().child(imagePath);
      final url = await ref.getDownloadURL();
      return url;
    } catch (e) {
      print('Error loading image: $e');
      return null;
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const UserHomePage()),
      );
    } else if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ProfilePage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[400],
        title: const Text('Daftar PEKA Saya', textAlign: TextAlign.center),
        automaticallyImplyLeading: false,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('observations')
            .where('userId', isEqualTo: userId)
            .orderBy('timestamp', descending: false)
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

              // Filter answers by targetQuestionId
              var filteredAnswers = answers.where((answer) => answer['questionId'] == targetQuestionId).toList();

              if (filteredAnswers.isEmpty) {
                return Container(); // Skip this item if there are no relevant answers
              }

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
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: filteredAnswers.map((answer) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: FutureBuilder<String?>(
                            future: _getImageUrl('adminprofile.jpg'), // Static image path
                            builder: (context, imageSnapshot) {
                              if (imageSnapshot.connectionState == ConnectionState.waiting) {
                                return const CircularProgressIndicator();
                              }

                              if (imageSnapshot.hasError) {
                                return Text('Error loading image: ${imageSnapshot.error}');
                              }

                              if (imageSnapshot.hasData && imageSnapshot.data != null) {
                                return Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Image.network(
                                        imageSnapshot.data!,
                                        height: 100, // Adjust size as needed
                                        width: 100, // Fixed width
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    const SizedBox(width: 8.0), // Space between image and text
                                    Expanded(
                                      child: Text(
                                        '${answer['answer']}',
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                    ),
                                  ],
                                );
                              } else {
                                return Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Container(
                                        width: 100, // Placeholder width for alignment
                                        height: 100,
                                        color: Colors.grey[200], // Placeholder color
                                      ),
                                    ),
                                    const SizedBox(width: 8.0), // Space between image and text
                                    Expanded(
                                      child: Text(
                                        '${answer['answer']}',
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                    ),
                                  ],
                                );
                              }
                            },
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 8.0),
                    // Display timestamp
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          '${doc['timestamp']?.toDate().toString() ?? 'No timestamp'}',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[700],
                          ),
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
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
