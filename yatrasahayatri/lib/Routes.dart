import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:yatrasahayatri/models/TripModel.dart';
import 'package:yatrasahayatri/uis/DashboardPage.dart';
import 'package:yatrasahayatri/uis/auth/LoginPage.dart';
import 'package:yatrasahayatri/uis/auth/SignupPage.dart';
import 'package:yatrasahayatri/uis/mapview/MapViewPage.dart';
import 'package:yatrasahayatri/uis/travel_plan/YourTravelPlanPage.dart';

class Routes {
  static void gotoBack(BuildContext context) {
    Navigator.of(context).pop();
  }

  static void gotoSplash(BuildContext context) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const LoginPage()),
      (Route<dynamic> route) => false,
    );
  }

  static void gotoLogin(BuildContext context) {
    PersistentNavBarNavigator.pushNewScreen(
      context,
      screen: const LoginPage(),
      withNavBar: false,
      pageTransitionAnimation: PageTransitionAnimation.cupertino,
    );
  }

  static void gotoSignUp(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const SignupPage()),
    );
  }

  static void gotoDashboard(BuildContext context) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const DashboardPage()),
      (Route<dynamic> route) => false,
    );
  }

  static void gotoMapView(
    BuildContext context,
    bool showTripPlan,
    TripModel? model,
    bool viewOnly,
  ) {
    //https://pub.dev/packages/persistent_bottom_nav_bar
    PersistentNavBarNavigator.pushNewScreen(
      context,
      screen: MapViewPage(
        showTripPlan: showTripPlan,
        viewOnly: viewOnly,
        model: model,
      ),
      withNavBar: false, // OPTIONAL VALUE. True by default.
      pageTransitionAnimation: PageTransitionAnimation.cupertino,
    );
  }

  static void gotoYourTravelPlan(
    BuildContext context,
    bool showTripPlan,
    TripModel? model,
  ) {
    PersistentNavBarNavigator.pushNewScreen(
      context,
      screen: YourTravelPlanPage(
        showTripPlan: showTripPlan,
        models: model,
      ),
      withNavBar: false,
      pageTransitionAnimation: PageTransitionAnimation.cupertino,
    );
  }
}
