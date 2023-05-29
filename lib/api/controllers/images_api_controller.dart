import 'dart:convert';
import 'dart:io';

import 'package:api_project/api/api_settings.dart';
import 'package:api_project/helpers/helpers.dart';
import 'package:api_project/models/student_image.dart';
import 'package:api_project/prefs/shared_pref_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

typedef UploadImageCallBack = void Function({
  required bool status,
  required String message,
  StudentImage? studentImage,
});

class ImagesApiController with Helpers {
  Future<void> uploadImage(BuildContext context,
      {required String path,
      required UploadImageCallBack uploadImageCallBack}) async {
    var url = Uri.parse(ApiSettings.images.replaceFirst('{id}', ''));
    var request = http.MultipartRequest('POST', url);
    http.MultipartFile imageFile =
        await http.MultipartFile.fromPath('image', path);
    request.files.add(imageFile);
    request.headers[HttpHeaders.authorizationHeader] = SharedPrefController().token;
    request.headers[HttpHeaders.acceptHeader] = 'application/json';
    var response = await request.send();
    response.stream.transform(utf8.decoder).listen((event) {
      print('Status Code: ${response.statusCode}');
      if (response.statusCode == 201) {
        var jsonResponse = jsonDecode(event);
        StudentImage studentImage =
            StudentImage.fromJson(jsonResponse['object']);
        uploadImageCallBack(
            status: true,
            message: jsonResponse['message'],
            studentImage: studentImage);

        showSnackBar(context: context, message: jsonResponse['message']);

      }

      else if (response.statusCode == 301) {
        uploadImageCallBack(
          status: false,
          message: 'Error',
        );
      }

      else if (response.statusCode == 400) {
        uploadImageCallBack(
          status: false,
          message: jsonDecode(event)['message'],
        );
      } else if (response.statusCode == 500) {
        uploadImageCallBack(
          status: false,
          message: 'Something went wrong!',
        );
      }
    });
  }

  Future<List<StudentImage>> images(BuildContext context) async {
    var url = Uri.parse(ApiSettings.images.replaceFirst('/{id}', ''));
    var response = await http.get(url, headers: {
      HttpHeaders.acceptHeader: 'application/json',
      HttpHeaders.authorizationHeader: SharedPrefController().token,
    });
    if (response.statusCode == 200 && context.mounted) {
      var imagesJsonArray = jsonDecode(response.body)['data'] as List;
      return imagesJsonArray
          .map((imageJsonObject) => StudentImage.fromJson(imageJsonObject))
          .toList();
    } else {
      showSnackBar(
        context: context,
        message: 'message',
        error: true,
      );
      return [];
    }
  }

  Future<bool> deleteImage(BuildContext context, {required int id}) async {
    var url =
        Uri.parse(ApiSettings.images.replaceFirst('/{id}', id.toString()));
    var response = await http.delete(url, headers: {
      HttpHeaders.acceptHeader: 'application/json',
      HttpHeaders.authorizationHeader: SharedPrefController().token,
    });

    if (response.statusCode == 200 && context.mounted) {
      showSnackBar(
          context: context, message: jsonDecode(response.body)['message']);
      return true;
    } else {
      showSnackBar(
          context: context,
          message: 'Something went wrong, please try again!',
          error: true);
    }
    return false;
  }
}
