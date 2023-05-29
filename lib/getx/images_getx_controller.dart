import 'package:api_project/api/controllers/images_api_controller.dart';
import 'package:api_project/models/student_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class ImageGetxController extends GetxController {

  RxList<StudentImage> studentImages = <StudentImage>[].obs;
  final ImagesApiController _imagesApiController = ImagesApiController();
  static ImageGetxController get to => Get.find();

  @override
  void onInit() {
    readImages();
    super.onInit();
  }

  Future<void> readImages() async {
    studentImages.value = await _imagesApiController.images();
  }

  Future<void> uploadImage(
      {required BuildContext context,
      required String path,
      required UploadImageCallBack uploadImageCallBack}) async {
    await _imagesApiController.uploadImage(
      context,
      path: path,
      uploadImageCallBack: (
          {required String message, required bool status, studentImage}) {
        if (status) studentImages.add(studentImage!);
        uploadImageCallBack(status: status, message: message);
      },
    );
  }

  Future<bool> deleteImage(BuildContext context, {required int id})  async {
    bool deleted = await _imagesApiController.deleteImage(context, id: id);
    if (deleted){
      int index = studentImages.indexWhere((element) => element.id == id);
      if (index != -1){
        studentImages.removeAt(index);
      }
    }
    return deleted;
  }

}
