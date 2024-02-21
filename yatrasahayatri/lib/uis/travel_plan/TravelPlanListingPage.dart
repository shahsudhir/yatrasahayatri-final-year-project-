import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yatrasahayatri/Routes.dart';
import 'package:yatrasahayatri/models/TripModel.dart';
import 'package:yatrasahayatri/models/TripPlanType.dart';
import 'package:yatrasahayatri/models/UserModel.dart';
import 'package:yatrasahayatri/providers/AppProvider.dart';
import 'package:yatrasahayatri/services/remote/TripApi.dart';
import 'package:yatrasahayatri/uis/travel_plan/dialogs/DeleteTripDialog.dart';
import 'package:yatrasahayatri/uis/travel_plan/dialogs/NearByPlacesDialog.dart';
import 'package:yatrasahayatri/utils/Commons.dart';

class TravelPlanListingPage extends StatefulWidget {
  const TravelPlanListingPage({Key? key}) : super(key: key);

  @override
  State<TravelPlanListingPage> createState() => _TravelPlanListingPageState();
}

class _TravelPlanListingPageState extends State<TravelPlanListingPage> {
  AppProvider? provider;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) async {
        loadApi();
      },
    );
  }

  loadApi() async {
    List<TripModel> models = await TripApi().getAll(
      user: provider!.user!,
      context: context,
    );
    provider!.tripHistory = models;
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<AppProvider>(context);

    Widget listing() {
      if (provider == null ||
          provider!.tripHistory == null ||
          provider!.tripHistory!.isEmpty) {
        return const Center(
          child: Text("No Trip plan"),
        );
      }

      List<TripModel> models = provider!.tripHistory!;

      return ListView.builder(
        itemCount: models.length, // Number of items to display
        itemBuilder: (BuildContext context, int index) {
          return Container(
            color: AppColors.white,
            margin: EdgeInsets.only(top: 4, bottom: 4),
            padding: EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      if (models[index].type != TripPlanType.NONE) {
                        Routes.gotoYourTravelPlan(context, true, models[index]);
                      }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.network(
                          models[index].content![0].image ??
                              "https://img.freepik.com/free-photo/abstract-grunge-decorative-relief-navy-blue-stucco-wall-texture-wide-angle-rough-colored-background_1258-28311.jpg?w=2000&t=st=1681412214~exp=1681412814~hmac=17fe5554ebc72cbecef9dbb6a6158eb7107188bf2071064db35c51e02d6bb0c8",
                          width: 68,
                          height: 68,
                          fit: BoxFit.cover,
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          flex: 5,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '${models[index].placeName}',
                                overflow: TextOverflow.clip,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Text(
                                    '${models[index].content![0].rating}',
                                  ),
                                  const SizedBox(width: 8),
                                  RatingView(
                                    max: 5,
                                    initial: models[index].content![0].rating,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () {
                      DeleteTripDialog.show(
                        context,
                        models[index],
                        provider!.user!,
                        (trip, user, context) {
                          TripApi()
                              .delete(
                            trip: trip,
                            user: user,
                            context: context,
                          )
                              .then((value) {
                            Navigator.pop(context);
                            loadApi();
                          });
                        },
                      );
                    },
                    child: const Icon(
                      Icons.cancel,
                      color: AppColors.grey,
                    ),
                  ),
                )
              ],
            ),
          );
        },
      );
    }

    return Scaffold(
      backgroundColor: AppColors.orangeLight,
      body: SafeArea(
        child: listing(),
      ),
    );
  }
}
