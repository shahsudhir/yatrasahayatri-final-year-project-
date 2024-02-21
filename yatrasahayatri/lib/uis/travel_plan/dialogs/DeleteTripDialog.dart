import 'package:flutter/material.dart';
import 'package:yatrasahayatri/models/TripModel.dart';
import 'package:yatrasahayatri/models/UserModel.dart';

class DeleteTripDialog{
  static show(
      BuildContext context,
      TripModel trip,
      UserModel user,
      Function(TripModel, UserModel, BuildContext) callback,
      ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Delete"),
          content: Text("Do you want to delete this plan?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                callback(trip, user, context);
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}