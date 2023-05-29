import 'dart:io';

import 'package:api_project/getx/images_getx_controller.dart';
import 'package:api_project/helpers/helpers.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UploadImageScreen extends StatefulWidget {
  const UploadImageScreen({Key? key}) : super(key: key);

  @override
  State<UploadImageScreen> createState() => _UploadImageScreenState();
}

class _UploadImageScreenState extends State<UploadImageScreen> with Helpers {
  final ImagePicker _imagePicker = ImagePicker();
  XFile? _pickedFile;
  double? _linearProgressValue = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Image'),
      ),
      body: Column(
        children: [
          LinearProgressIndicator(
            minHeight: 10,
            color: Colors.green,
            backgroundColor: Colors.blue.shade300,
            value: _linearProgressValue,
          ),
          Expanded(
            child: _pickedFile != null
                ? Image.file(File(_pickedFile!.path))
                : TextButton(
                    onPressed: () async => await _pickImage(),
                    style: TextButton.styleFrom(
                      minimumSize: const Size(double.infinity, 0),
                    ),
                    child: const Text('Pick Image to Upload'),
                  ),
          ),
          ElevatedButton.icon(
            onPressed: () async => await performUpload(),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
            ),
            icon: const Icon(Icons.cloud_upload),
            label: const Text(
              'UPLOAD',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        ],
      ),
    );
  }

  Future<void> _pickImage() async {
    XFile? imageFile = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
    );
    if (imageFile != null) {
      setState(() {
        _pickedFile = imageFile;
      });
    }
  }

  Future<void> performUpload() async {
    if (checkData()) {
      await uploadImage();
    }
  }

  bool checkData() {
    if (_pickedFile != null) {
      return true;
    }
    showSnackBar(
      context: context,
      message: 'Select Image to upload!',
      error: true,
    );
    return false;
  }

  Future<void> uploadImage() async {
    _changeProgressValue(value: null);
    ImageGetxController.to.uploadImage(
      context: context,
      path: _pickedFile!.path,
      uploadImageCallBack: (
          {required String message, required bool status, studentImage}) {
        if (status) {
          _changeProgressValue(value: 1);
          showSnackBar(context: context, message: message);
        } else {
          _changeProgressValue(value: 0);
          showSnackBar(context: context, message: message, error: true);
        }
      },
    );
  }

  void _changeProgressValue({double? value}) {
    setState(() {
      _linearProgressValue = value;
    });
  }
}
