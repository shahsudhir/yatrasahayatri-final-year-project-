import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:yatrasahayatri/animation/CustomAnimation.dart';
import 'package:yatrasahayatri/models/UserModel.dart';
import 'package:yatrasahayatri/services/InternetConnection.dart';
import 'package:yatrasahayatri/utils/Commons.dart';

//cmd--> ipconfig --> IPv4 address
String BASE_URL = "http://192.168.0.103:3000"; //For local access
//String BASE_URL =
//"https://us-central1-mereka-dev.cloudfunctions.net/test_app"; //For remote access

class AuthApi {
  static Future<UserModel?> login({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    EasyLoadingView.show(message: '');
    if (await InternetConnection.hasConnection()) {
      var url = Uri.parse(
        '${BASE_URL}/api/auth/login/email-password',
      );
      print("Url------> ${url}");

      var body = jsonEncode({
        "email": email,
        "password": password,
      });
      var header = {'Content-Type': 'application/json'};
      var response = await http.post(url, body: body, headers: header);
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      try {
        var valueMap = jsonDecode(response.body) as Map<String, dynamic>;
        UserModel model = UserModel.fromJson(valueMap);
        return model;
      } catch (e) {
        return null;
      } finally {
        EasyLoadingView.dismiss();
      }
    } else {
      EasyLoadingView.dismiss();
      Commons.showMessage(
        context,
        "Please check your internet connectivity and try again",
      );
      return null;
    }
  }

  static Future<UserModel?> signup({
    required String email,
    required String password,
    required String fullName,
    required BuildContext context,
  }) async {
    EasyLoadingView.show(message: '');
    if (await InternetConnection.hasConnection()) {
      var url = Uri.parse(
        '${BASE_URL}/api/auth/signup/email-password',
      );
      print("Url------> ${url}");

      var body = jsonEncode({
        "email": email,
        "password": password,
        "fullName": fullName,
      });
      var header = {'Content-Type': 'application/json'};
      var response = await http.post(url, body: body, headers: header);
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      try {
        var valueMap = jsonDecode(response.body) as Map<String, dynamic>;
        UserModel model = UserModel.fromJson(valueMap);
        return model;
      } catch (e) {
        return null;
      } finally {
        EasyLoadingView.dismiss();
      }
    } else {
      EasyLoadingView.dismiss();
      Commons.showMessage(
        context,
        "Please check your internet connectivity and try again",
      );
      return null;
    }
  }

  static Future<UserModel?> updateUserDetail({
    required String email,
    required String password,
    required String fullName,
    required UserModel model,
    required BuildContext context,
  }) async {
    EasyLoadingView.show(message: '');
    if (await InternetConnection.hasConnection()) {
      var url = Uri.parse(
        '${BASE_URL}/api/auth/user/update-detail',
      );
      print("Url------> ${url}");

      Map<String, dynamic> map = {};
      if (model.data!.email != email) {
        map["email"] = email;
      }
      if (model.data!.fullName != fullName) {
        map["fullName"] = fullName;
      }
      map["password"] = password;

      var body = jsonEncode(map);
      var header = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${model.token}',
      };
      var response = await http.patch(url, body: body, headers: header);
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      try {
        var valueMap = jsonDecode(response.body) as Map<String, dynamic>;
        UserModel model = UserModel.fromJson(valueMap);
        return model;
      } catch (e) {
        return null;
      } finally {
        EasyLoadingView.dismiss();
      }
    } else {
      EasyLoadingView.dismiss();
      Commons.showMessage(
        context,
        "Please check your internet connectivity and try again",
      );
      return null;
    }
  }
}
