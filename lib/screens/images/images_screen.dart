import 'package:api_project/api/api_settings.dart';
import 'package:api_project/getx/images_getx_controller.dart';
import 'package:api_project/models/student_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ImagesScreen extends StatefulWidget {
  const ImagesScreen({Key? key}) : super(key: key);

  @override
  State<ImagesScreen> createState() => _ImagesScreenState();
}

class _ImagesScreenState extends State<ImagesScreen> {
  final ImageGetxController _imageGetxController =
      Get.put(ImageGetxController());
  late Future<List<StudentImage>> _future;
  List<StudentImage> _studentImages = <StudentImage>[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Images'),
        actions: [
          IconButton(
            onPressed: () =>
                Navigator.pushNamed(context, '/upload_image_screen'),
            icon: const Icon(Icons.cloud_upload),
          ),
        ],
      ),
      body: GetX<ImageGetxController>(
        builder: (controller) {
          if (controller.studentImages.isNotEmpty) {
            return GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              itemCount: controller.studentImages.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
              ),
              itemBuilder: (context, index) {
                return Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Image.network(
                    'http://demo-api.mr-dev.tech/images/2023-05-28%2017:41:23_student.jpg'
                    // ApiSettings.getImageUrl(
                    //     controller.studentImages[index].image),
                  ),
                );
              },
            );
          } else {
            return const Center(
              child: Column(
                children: [
                  Icon(
                    Icons.warning,
                    size: 80,
                    color: Colors.grey,
                  ),
                  Text(
                    'NO DATA!',
                    style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
