import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yatrasahayatri/Routes.dart';
import 'package:yatrasahayatri/models/TripModel.dart';
import 'package:yatrasahayatri/models/TripPlanType.dart';
import 'package:yatrasahayatri/providers/AppProvider.dart';
import 'package:yatrasahayatri/services/local/LocalStorage.dart';
import 'package:yatrasahayatri/utils/Commons.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController timeController = TextEditingController();
    AppProvider provider = Provider.of<AppProvider>(context);
    bool showTimeField = false;
    String showTimeText = "";
    if (provider.planType != TripPlanType.NONE) {
      showTimeField = true;
      if (provider.planType == TripPlanType.WITH_IN_CITY) {
        showTimeText = "Enter Time Hours";
      }
      if (provider.planType == TripPlanType.OUT_STATION) {
        showTimeText = "Enter Time Days";
      }
    }

    void createNewTrip() {
      provider.trip = TripModel();
      provider.trip!.type = provider.planType;
      if (provider.trip!.type == TripPlanType.OUT_STATION) {
        provider.trip!.daysContent = provider.trip!.setDaysContent(
          int.parse(
            timeController.text.toString().trim(),
          ),
        );
      } else {
        provider.trip!.daysContent = provider.trip!.setDayContent(
          int.parse(
            timeController.text.toString().trim(),
          ),
        );
      }
    }

    return Scaffold(
      backgroundColor: AppColors.orangeLight,
      body: SafeArea(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.grey[400],
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  padding: EdgeInsets.all(8),
                  margin: EdgeInsets.all(20),
                  child: GestureDetector(
                    onTap: () {
                      LocalStorage.saveAuthCredentials(null);
                      Routes.gotoLogin(context);
                    },
                    child: const Icon(
                      Icons.logout,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 100),
            Center(
              child: Container(
                margin: const EdgeInsets.only(
                  bottom: 64,
                  left: 16,
                  right: 16,
                ),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                  color: AppColors.white,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 32),
                    const Text(
                      "Select your Trip plan",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.blue,
                      ),
                    ),
                    const SizedBox(height: 36),
                    ChooseTripPlan(
                      provider: provider,
                    ),
                    const SizedBox(height: 36),
                    showTimeField
                        ? Container(
                            padding: const EdgeInsets.only(left: 24, right: 24),
                            child: TextField(
                              controller: timeController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 5.0,
                                  horizontal: 10.0,
                                ),
                                filled: true,
                                fillColor: Colors.white,
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: const BorderSide(
                                    color: AppColors.blue,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: const BorderSide(
                                    color: AppColors.blue,
                                  ),
                                ),
                                hintText: showTimeText,
                              ),
                            ),
                          )
                        : Container(),
                    showTimeField ? const SizedBox(height: 36) : Container(),
                    Container(
                      margin: const EdgeInsets.only(left: 22, right: 22),
                      child: ElevatedButton(
                        onPressed: () {
                          if (provider.planType == TripPlanType.NONE) {
                            Commons.showMessage(
                              context,
                              "Please choose your trip plan",
                            );
                          } else if (timeController.text.isEmpty) {
                            Commons.showMessage(
                              context,
                              "Please enter how much time you want to spend",
                            );
                          } else {
                            createNewTrip();
                            Routes.gotoMapView(context, false, null, false);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                            onPrimary: AppColors.blue,
                            shadowColor: AppColors.blue,
                            elevation: 18,
                            padding: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15))),
                        child: Ink(
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                                colors: [AppColors.blue, AppColors.blue]),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Container(
                            width: 180,
                            height: 50,
                            alignment: Alignment.center,
                            child: const Text(
                              'Proceed >',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                letterSpacing: 2,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ChooseTripPlan extends StatelessWidget {
  final AppProvider provider;

  const ChooseTripPlan({
    Key? key,
    required this.provider,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: () {
                provider.planType = TripPlanType.WITH_IN_CITY;
              },
              child: Container(
                height: 96,
                width: 96,
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                  border: Border.all(color: Colors.grey, width: 1),
                  color: provider.planType == TripPlanType.WITH_IN_CITY
                      ? Colors.grey
                      : Colors.transparent,
                ),
                child: Image.asset("images/ic_destination.png"),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              "With-in City",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.normal,
                color: provider.planType == TripPlanType.WITH_IN_CITY
                    ? Colors.grey[900]
                    : Colors.grey[400],
              ),
            ),
          ],
        ),
        const SizedBox(width: 24),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: () {
                provider.planType = TripPlanType.OUT_STATION;
              },
              child: Container(
                height: 96,
                width: 96,
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                  border: Border.all(color: Colors.grey, width: 1),
                  color: provider.planType == TripPlanType.OUT_STATION
                      ? Colors.grey
                      : Colors.transparent,
                ),
                child: Image.asset("images/ic_globe_earth.png"),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              "Outstation",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.normal,
                color: provider.planType == TripPlanType.OUT_STATION
                    ? Colors.grey[900]
                    : Colors.grey[400],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
