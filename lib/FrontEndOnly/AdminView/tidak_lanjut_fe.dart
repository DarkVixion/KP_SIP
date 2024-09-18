import 'package:flutter/material.dart';

class TindaklanjutDetailPage extends StatelessWidget {
  final Map<String, dynamic> tindaklanjut;

  const TindaklanjutDetailPage({super.key, required this.tindaklanjut});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tindaklanjut Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Image: ${tindaklanjut['img']}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 13),
            Text(
              'Deskripsi: ${tindaklanjut['deskripsi']}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 13),
            Text(
              'Tanggal: ${tindaklanjut['tanggal']}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 13),
            Text(
              'Tipe: ${tindaklanjut['tipe']}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 13),
            Text(
              'Status: ${tindaklanjut['status']}',
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
