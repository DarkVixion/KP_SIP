import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

class Test extends StatefulWidget {
  @override
  _TestState createState() => _TestState();
}

class _TestState extends State<Test> {
  bool isDownloading = false;
  String progress = '';

  Future<void> downloadFile() async {
    Dio dio = Dio();
    try {
      setState(() {
        isDownloading = true;
      });

      // Define the URL and the file path
      String url = "https://example.com/sample.pdf";
      String fileName = url.split('/').last;

      // Get the directory to save the file
      var dir = await getApplicationDocumentsDirectory();

      await dio.download(
        url,
        "${dir.path}/$fileName",
        onReceiveProgress: (received, total) {
          if (total != -1) {
            setState(() {
              progress = "${(received / total * 100).toStringAsFixed(0)}%";
            });
          }
        },
      );

      setState(() {
        isDownloading = false;
        progress = "Download Completed";
      });

      // Display the file path after download
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("File saved to ${dir.path}/$fileName")),
      );
    } catch (e) {
      setState(() {
        isDownloading = false;
        progress = "Download Failed";
      });
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Download Button Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            isDownloading
                ? CircularProgressIndicator()
                : ElevatedButton(
              onPressed: downloadFile,
              child: Text("Download File"),
            ),
            SizedBox(height: 20),
            Text(progress),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: Test(),
  ));
}
