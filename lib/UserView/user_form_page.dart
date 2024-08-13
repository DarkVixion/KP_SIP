import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttersip/UserView/form_update.dart';


class UserFormPage1 extends StatefulWidget {
  const UserFormPage1({super.key});

  @override
  _UserFormPage1State createState() => _UserFormPage1State();
}

class _UserFormPage1State extends State<UserFormPage1> {
  final Map<String, String?> _selectedValues = {}; // Store selected values for each question
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  void _onSelected(String question, String? value) {
    setState(() {
      _selectedValues[question] = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Questions List'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: StreamBuilder<QuerySnapshot>(
          stream: firestore.collection('questions').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData) {
              return const Center(child: Text('No data found.'));
            }

            var questions = snapshot.data!.docs;

            return ListView.builder(
              itemCount: questions.length,
              itemBuilder: (context, index) {
                var questionData = questions[index];
                var question = questionData['question'] as String;
                var options = List<String>.from(questionData['options'] as List<dynamic>);

                return QuestionBox(
                  question: question,
                  options: options,
                  selectedValue: _selectedValues[question],
                  onSelected: (value) {
                    _onSelected(question, value);
                  },
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          if (_selectedValues.isNotEmpty) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => UserFormUpdate(
                  selectedValues: _selectedValues,
                  userId: auth.currentUser?.uid ?? '', // Pass the user's UID
                ),
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('No answers selected')),
            );
          }
        },
        label: const Text('Next'),
        icon: const Icon(Icons.navigate_next),
        backgroundColor: Colors.blue,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

class QuestionBox extends StatefulWidget {
  final String question;
  final List<String> options;
  final String? selectedValue;
  final Function(String?) onSelected;

  const QuestionBox({super.key,
    required this.question,
    required this.options,
    required this.selectedValue,
    required this.onSelected,
  });

  @override
  _QuestionBoxState createState() => _QuestionBoxState();
}

class _QuestionBoxState extends State<QuestionBox> {
  String? _selectedValue;
  final TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedValue = widget.selectedValue;
    if (_selectedValue != null && _selectedValue != 'Input') {
      _textController.text = _selectedValue!;
    }

    _textController.addListener(() {
      if (_selectedValue == 'Input') {
        widget.onSelected(_textController.text);
      }
    });
  }

  @override
  void didUpdateWidget(covariant QuestionBox oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedValue != oldWidget.selectedValue) {
      setState(() {
        _selectedValue = widget.selectedValue;
        if (_selectedValue != null && _selectedValue != 'Input') {
          _textController.text = _selectedValue!;
        } else {
          _textController.clear();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blueGrey),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.question,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16.0),
          ...widget.options.map((option) {
            return RadioListTile<String>(
              title: Text(option),
              value: option,
              groupValue: _selectedValue,
              onChanged: (value) {
                setState(() {
                  _selectedValue = value;
                  if (value != 'Input') {
                    _textController.clear();
                  }
                });
                widget.onSelected(value);
              },
            );
          }),
          Row(
            children: [
              Radio<String>(
                value: 'Input',
                groupValue: _selectedValue,
                onChanged: (value) {
                  setState(() {
                    _selectedValue = value;
                  });
                  widget.onSelected(value);
                },
              ),
              Expanded(
                child: TextField(
                  controller: _textController,
                  decoration: const InputDecoration(
                    labelText: 'Enter text',
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
