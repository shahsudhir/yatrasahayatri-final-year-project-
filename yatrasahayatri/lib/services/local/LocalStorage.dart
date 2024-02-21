import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:yatrasahayatri/models/UserModel.dart';

class LocalStorage {
  static Future<void> saveAuthCredentials(UserModel? model) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (model == null) {
      await prefs.setString('auth_credentials', "");
    } else {
      await prefs.setString('auth_credentials', jsonEncode(model.toJson()));
    }
  }

  static Future<UserModel?> getAuthCredentials() async {
    UserModel? model;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var value = prefs.getString('auth_credentials') ?? "";
    print("getAuthCredentials::value-----> ${value}");
    if (value != "") {
      var encodedString = jsonDecode(value);
      model = UserModel.fromJson(encodedString);
      print("getAuthCredentials::model-----> ${model.toJson()}");
    }
    return model;
  }
}
