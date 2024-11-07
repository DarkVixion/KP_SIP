import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:fluttersip/constants/constants.dart';

class UserHomePageTest2 extends StatefulWidget {
  @override
  _UserHomePageTest2State createState() => _UserHomePageTest2State();
}

class _UserHomePageTest2State extends State<UserHomePageTest2> {
  Dio dio = Dio(); // Initialize Dio for network requests
  List<Map<String, dynamic>> tindaklanjuts = []; // To store fetched notifications
  bool isLoading = true; // Loading state to show spinner while fetching data

  @override
  void initState() {
    super.initState();
    fetchTindaklanjuts(); // Fetch notifications when the page loads
  }

  // Fetch new tindaklanjuts from the backend
  Future<void> fetchTindaklanjuts() async {
    try {
      setState(() {
        isLoading = true;
      });

      // Replace with your actual API endpoint
      final response = await dio.get('${url}tindaklanjuts');

      if (response.statusCode == 202) {
        List data = response.data;
        setState(() {
          tindaklanjuts = data.map((item) {
            return {
              'title': 'Tindak Lanjut: ${item['status']}', // Using the status as title
              'description': item['deskripsi'], // Description from the API
              'timestamp': item['created_at'], // Assuming there's a 'tanggal' field for timestamp
            };
          }).toList();
          isLoading = false;
        });
      } else {
        // Handle error
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching tindaklanjuts: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
        const Text('Notifications'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator()) // Show loading spinner while fetching data
          : ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: tindaklanjuts.length,
        itemBuilder: (context, index) {
          final notification = tindaklanjuts[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 10),
            child: ListTile(
              leading: const Icon(Icons.notifications, color: Colors.blue),
              title: Text(
                notification['title']!,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(notification['description']!),
                  const SizedBox(height: 8.0),
                  Text(
                    notification['timestamp']!,
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                // Handle notification tap here
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Notification tapped!')),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
