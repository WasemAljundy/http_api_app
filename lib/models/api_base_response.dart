import 'package:api_project/models/user.dart';

class ApiBaseResponse {
  late bool status;
  late String message;
  late List<User> users;

  ApiBaseResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      users = <User>[];
      json['data'].forEach((v) {
        users.add(User.fromJson(v));
      });
    }
  }

}