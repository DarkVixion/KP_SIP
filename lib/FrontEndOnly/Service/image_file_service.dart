import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

class UploadOrCaptureImage extends StatefulWidget {
  const UploadOrCaptureImage({super.key});

  @override
  _UploadOrCaptureImageState createState() => _UploadOrCaptureImageState();
}

class _UploadOrCaptureImageState extends State<UploadOrCaptureImage> {


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (_image != null) Image.file(_image!),
        if (_file != null) Text("Selected file: ${_file!.path.split('/').last}"),
        const SizedBox(height: 20),
        ElevatedButton.icon(
          onPressed: _pickImage,
          icon: const Icon(Icons.camera_alt),
          label: const Text("Take a Picture"),
        ),
        const SizedBox(height: 10),
        ElevatedButton.icon(
          onPressed: _uploadFile,
          icon: const Icon(Icons.upload_file),
          label: const Text("Upload File"),
        ),
      ],
    );
  }
}