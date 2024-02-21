import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:yatrasahayatri/models/TripModel.dart';
import 'package:yatrasahayatri/models/TripPlanType.dart';
import 'package:yatrasahayatri/models/UserModel.dart';

class AppProvider extends ChangeNotifier {
  UserModel? _user;
  TripModel? _trip;
  List<TripModel>? _tripHistory = [];
  LatLng? _currentLocation;
  TripPlanType _planType = TripPlanType.NONE;

  //getters
  UserModel? get user => _user;

  TripModel? get trip => _trip;

  LatLng? get currentLocation => _currentLocation;

  TripPlanType get planType => _planType;

  List<TripModel>? get tripHistory => _tripHistory;

  //setters
  set user(UserModel? value) {
    _user = value;

    notifyListeners();
  }

  set trip(TripModel? value) {
    _trip = value;
    notifyListeners();
  }

  set tripHistory(List<TripModel>? value) {
    _tripHistory = value;
  }

  set currentLocation(LatLng? value) {
    _currentLocation = value;
    notifyListeners();
  }

  set planType(TripPlanType value) {
    _planType = value;
    notifyListeners();
  }
}
