import 'dart:convert';

import 'package:api_project/api/api_settings.dart';
import 'package:api_project/models/api_base_response.dart';
import 'package:api_project/models/category.dart';
import 'package:api_project/models/user.dart';
import 'package:http/http.dart' as http;
class UserApiController {

  Future<List<User>> getUsers() async {
    var url = Uri.parse(ApiSettings.users);
    var response = await http.get(url);

    if(response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      ApiBaseResponse apiBaseResponse = ApiBaseResponse.fromJson(jsonResponse);
      return apiBaseResponse.users;
    }
    else {
      // error message
    }
    return [];
  }

  Future<List<Category>> getCategories() async {
    var url = Uri.parse(ApiSettings.categories);
    var response = await http.get(url);

    if(response.statusCode == 200) {
      var categoryJsonArray = jsonDecode(response.body)['data'] as List;
      List<Category> categories = categoryJsonArray.map((jsonObject) => Category.fromJson(jsonObject)).toList();
      return categories;
    }
    return [];
  }
}