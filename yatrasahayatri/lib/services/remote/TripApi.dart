import 'package:flutter/material.dart';
import 'package:yatrasahayatri/animation/CustomAnimation.dart';
import 'package:yatrasahayatri/models/TripModel.dart';
import 'package:yatrasahayatri/models/UserModel.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:yatrasahayatri/services/InternetConnection.dart';
import 'package:yatrasahayatri/services/remote/AuthApi.dart';
import 'package:yatrasahayatri/utils/Commons.dart';

class TripApi {
  Future add({
    required TripModel trip,
    required UserModel user,
    required BuildContext context,
  }) async {
    EasyLoadingView.show(message: '');
    if (await InternetConnection.hasConnection()) {
      var url = Uri.parse(
        '${BASE_URL}/api/trip/add',
      );
      print("Url------> ${url}");
      var body = jsonEncode(trip.toJson());

      var header = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${user.token}',
      };
      var response = await http.post(url, body: body, headers: header);
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      try {
        var valueMap = jsonDecode(response.body) as Map<String, dynamic>;
        // UserModel model = UserModel.fromJson(valueMap);
        // return model;
        return "Success";
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
    }
  }

  Future<List<TripModel>> getAll({
    required UserModel user,
    required BuildContext context,
  }) async {
    EasyLoadingView.show(message: '');
    List<TripModel> resultModel = [];
    if (await InternetConnection.hasConnection()) {
      var url = Uri.parse(
        '${BASE_URL}/api/trip/list',
      );
      print("Url------> ${url}");

      var header = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${user.token}',
      };
      var response = await http.get(url, headers: header);
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      try {
        var valueMap = jsonDecode(response.body) as Map<String, dynamic>;
        if (valueMap["success"]) {
          resultModel = valueMap["data"]
              .map((i) => TripModel.fromJson(i))
              .toList()
              .cast<TripModel>();
        }
        return resultModel;
      } catch (e) {
        return resultModel;
      } finally {
        EasyLoadingView.dismiss();
      }
    } else {
      EasyLoadingView.dismiss();
      Commons.showMessage(
        context,
        "Please check your internet connectivity and try again",
      );
      return resultModel;
    }
  }

  Future<List<TripModel>> delete({
    required TripModel trip,
    required UserModel user,
    required BuildContext context,
  }) async {
    EasyLoadingView.show(message: '');
    List<TripModel> resultModel = [];
    if (await InternetConnection.hasConnection()) {
      final url = Uri.parse('${BASE_URL}/api/trip/delete/${trip.id}');
      print("Url------> ${url}");

      var header = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${user.token}',
      };
      var response = await http.delete(url, headers: header);
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      try {
        var valueMap = jsonDecode(response.body) as Map<String, dynamic>;
        // if (valueMap["success"]) {
        //   resultModel = valueMap["data"]
        //       .map((i) => TripModel.fromJson(i))
        //       .toList()
        //       .cast<TripModel>();
        // }
        return resultModel;
      } catch (e) {
        return resultModel;
      } finally {
        EasyLoadingView.dismiss();
      }
    } else {
      EasyLoadingView.dismiss();
      Commons.showMessage(
        context,
        "Please check your internet connectivity and try again",
      );
      return resultModel;
    }
  }

  Future<dynamic> update({
    required TripModel trip,
    required UserModel user,
  }) async {
    List<TripModel> resultModel = [];
    final url = Uri.parse('${BASE_URL}/api/trip/update/${trip.id}');
    print("Url------> ${url}");

    var header = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${user.token}',
    };
    var response = await http.patch(url, headers: header);
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
    try {
      var valueMap = jsonDecode(response.body) as Map<String, dynamic>;
      // if (valueMap["success"]) {
      //   resultModel = valueMap["data"]
      //       .map((i) => TripModel.fromJson(i))
      //       .toList()
      //       .cast<TripModel>();
      // }
      return resultModel;
    } catch (e) {
      return resultModel;
    }
  }
}
