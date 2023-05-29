import 'dart:convert';
import 'dart:io';

import 'package:api_project/api/api_settings.dart';
import 'package:api_project/helpers/helpers.dart';
import 'package:api_project/models/student.dart';
import 'package:api_project/prefs/shared_pref_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class AuthApiController with Helpers {
  Future<bool> register(BuildContext context,
      {required Student student}) async {
    var url = Uri.parse(ApiSettings.register);
    var response = await http.post(url, body: {
      'full_name': student.fullName,
      'email': student.email,
      'password': student.password,
      'gender': student.gender,
    });

    if (response.statusCode == 201 && context.mounted) {
      showSnackBar(
        context: context,
        message: jsonDecode(response.body)['message'],
      );
      return true;
    } else if (response.statusCode == 400 && context.mounted) {
      showSnackBar(
        context: context,
        message: jsonDecode(response.body)['message'],
        error: true,
      );
    }
    return false;
  }

  Future<bool> login(BuildContext context,
      {required String email, required String password}) async {
    var url = Uri.parse(ApiSettings.login);
    var response = await http.post(url, body: {
      'email': email,
      'password': password,
    });
    if (response.statusCode == 200 && context.mounted) {
      var jsonObject = jsonDecode(response.body)['object'];
      Student student = Student.fromJson(jsonObject);
      SharedPrefController().saveStudent(student: student);
      showSnackBar(
        context: context,
        message: jsonDecode(response.body)['message'],
      );
      return true;
    } else if (response.statusCode == 400) {
      showSnackBar(
        context: context,
        message: jsonDecode(response.body)['message'],
        error: true,
      );
      return false;
    }
    return false;
  }

  Future<bool> logout() async {
    var url = Uri.parse(ApiSettings.logout);
    var response = await http.get(url, headers: {
      HttpHeaders.authorizationHeader: SharedPrefController().token,
      HttpHeaders.acceptHeader: 'application/json',
    });

    if (response.statusCode == 200 || response.statusCode == 401) {
      SharedPrefController().clear();
      return true;
    }
    return false;
  }

  Future<bool> forgetPassword(BuildContext context,
      {required String email}) async {
    var url = Uri.parse(ApiSettings.forgetPassword);
    var response = await http.post(url, body: {
      'email': email,
    });

    if (response.statusCode == 200 && context.mounted) {
      showSnackBar(
        context: context,
        message: jsonDecode(response.body)['message'],
      );
      print(jsonDecode(response.body)['code']);
      return true;
    } else if (response.statusCode == 400 && context.mounted) {
      showSnackBar(
        context: context,
        message: jsonDecode(response.body)['message'],
        error: true,
      );
    } else {
      showSnackBar(
        context: context,
        message: 'Something went wrong, please try again!',
        error: true,
      );
    }
    return false;
  }

  Future<bool> resetPassword(
    BuildContext context, {
    required String email,
    required String code,
    required String password,
  }) async {
    var url = Uri.parse(ApiSettings.resetPassword);
    var response = await http.post(
      url,
      body: {
        'email': email,
        'code': code,
        'password': password,
        'password_confirmation': password,
      },
      headers: {
        HttpHeaders.acceptHeader: 'application/json',
      },
    );

    if (response.statusCode == 200 && context.mounted) {
      showSnackBar(
        context: context,
        message: jsonDecode(response.body)['message'],
      );
      return true;
    }
    else if (response.statusCode == 400 && context.mounted) {
      showSnackBar(
        context: context,
        message: jsonDecode(response.body)['message'],
        error: true,
      );
    }
    else if (response.statusCode == 500) {
      showSnackBar(
        context: context,
        message: 'Server Error',
        error: true,
      );
    }
    return false;
  }

}
