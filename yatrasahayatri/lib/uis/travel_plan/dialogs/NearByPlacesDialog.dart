import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:yatrasahayatri/Routes.dart';
import 'package:yatrasahayatri/models/NearByPlacesModal.dart';
import 'package:yatrasahayatri/models/TripModel.dart';
import 'package:yatrasahayatri/models/TripPlanType.dart';
import 'package:yatrasahayatri/providers/AppProvider.dart';
import 'package:yatrasahayatri/services/geolocation/GeolocationApi.dart';
import 'package:yatrasahayatri/uis/travel_plan/YourTravelPlanPage.dart';
import 'package:yatrasahayatri/uis/travel_plan/dialogs/HourSpentDialog.dart';
import 'package:yatrasahayatri/utils/Commons.dart';

class NearByPlacesDialog {
  static show(
    BuildContext context,
    String title,
    int whichDay,
    TripPlanType planType,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: NearByPlaceTabView(
            title: title,
            whichDay: whichDay,
            planType: planType,
          ),
        );
      },
    );
  }
}

class NearByPlaceTabView extends StatefulWidget {
  final String title;
  final int whichDay;
  final TripPlanType planType;

  const NearByPlaceTabView({
    Key? key,
    required this.title,
    required this.whichDay,
    required this.planType,
  }) : super(key: key);

  @override
  State<NearByPlaceTabView> createState() => _NearByPlaceTabViewState();
}

class _NearByPlaceTabViewState extends State<NearByPlaceTabView>
    with TickerProviderStateMixin {
  AppProvider? provider;
  late TabController _tabController;
  List<Widget>? myTabs;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        myTabs = [];
        NearByPlacesType.values.forEach((element) {
          String day = element.value ?? "";
          myTabs!.add(SizedBox(
            key: Key("${day}"),
            child: Tab(
              text: "${day}",
              key: Key("${day}"),
            ),
          ));
        });
        _tabController = TabController(vsync: this, length: myTabs!.length);
        setState(() {});
      },
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<Widget> tabUis() {
    List<Widget> views = [];
    if (myTabs != null) {
      for (int i = 0; i < myTabs!.length; i++) {
        views.add(NearByPlacesItemView(
          index: i,
          whichDay: widget.whichDay,
          provider: provider!,
          planType: widget.planType,
        ));
      }
    }
    return views.toList();
  }

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<AppProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.blue,
        centerTitle: true,
        leading: Container(),
        title: Container(
          child: Text(
            widget.title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.white,
            ),
          ),
        ),
        bottom: myTabs != null
            ? TabBar(
                controller: _tabController,
                tabs: myTabs!,
                isScrollable: true,
              )
            : CustomAppBar(),
      ),
      body: Stack(
        children: [
          GestureDetector(
            onHorizontalDragUpdate: (details) {},
            child: myTabs != null
                ? TabBarView(
                    controller: _tabController,
                    children: tabUis(),
                  )
                : Container(),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Routes.gotoBack(context);
                    },
                    style: ElevatedButton.styleFrom(
                      elevation: 18,
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0),
                      ),
                    ),
                    child: Ink(
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.blue, width: 1),
                        color: AppColors.blue,
                        borderRadius: BorderRadius.circular(0),
                      ),
                      child: Container(
                        height: 45,
                        alignment: Alignment.center,
                        child: const Text(
                          'Submit',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            letterSpacing: 2,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Routes.gotoBack(context);
                    },
                    style: ElevatedButton.styleFrom(
                      elevation: 18,
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: Ink(
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.blue, width: 1),
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(0),
                      ),
                      child: Container(
                        height: 45,
                        alignment: Alignment.center,
                        child: const Text(
                          'Cancel',
                          style: TextStyle(
                            fontSize: 18,
                            color: AppColors.blue,
                            letterSpacing: 2,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),
        ],
      ),
    );
  }
}

class NearByPlacesItemView extends StatefulWidget {
  final int index;
  final int whichDay;
  final AppProvider provider;
  final TripPlanType planType;

  NearByPlacesItemView({
    Key? key,
    required this.index,
    required this.whichDay,
    required this.provider,
    required this.planType,
  }) : super(key: key);

  @override
  State<NearByPlacesItemView> createState() => _NearByPlacesItemViewState();
}

class _NearByPlacesItemViewState extends State<NearByPlacesItemView> {
  List<NearByPlacesModal>? modals;

  @override
  void initState() {
    super.initState();
    search(widget.index);
  }

  Future<void> search(int index) async {
    NearByPlacesType type = NearByPlacesType.values[index];
    List<NearByPlacesModal> values = await GeolocationApi.getPlacesInfo(
      latLng: widget.provider.currentLocation!,
      type: type.name,
    );
    modals = values;
    setState(() {});
  }

  multipleDayCalculateSpendingHour(
      NearByPlacesModal nearByPlacesModal, int index, int hours) {
    String? message;
    TripModel? tripModel = widget.provider.trip;
    List<Content>? model = tripModel?.content;
    int whichDay = widget.whichDay;
    int maxHour = tripModel?.daysContent![whichDay - 1].maxHours ?? 0;
    if (model == null || model.length < 1) {
      if (maxHour < hours) {
        int remainingHour = (maxHour - hours).abs();
        message =
            "Your spending hours is ${hours}, remaining hours is ${maxHour}. Time exceed by ${remainingHour} hours.";
      }
    } else {
      int m = maxHour;
      model.forEach((element) {
        if (element.whichDay == whichDay) {
          m = m - element.hours!;
        }
      });
      if (m <= 0) {
        message =
            "Your spending hours is ${hours}, remaining hours is ${m.abs()}. Time exceed by ${hours} hours.";
      } else if (m < hours) {
        int remainingHour = (m - hours).abs();
        message =
            "Your spending hours is ${hours}, remaining hours is ${m.abs()}. Time exceed by ${remainingHour} hours.";
      }
    }
    return message;
  }

  addItem(NearByPlacesModal nearByPlacesModal, int index, int hours) {
    TripModel? tripModel = widget.provider.trip;
    List<Content>? model = tripModel?.content;
    int whichDay = widget.whichDay;
    if (model == null || model.length < 1) {
      var content = Content();
      content.name = nearByPlacesModal.name;
      content.rating = nearByPlacesModal.rating;
      content.placeId = nearByPlacesModal.place_id;
      content.hours = hours;
      content.whichDay = whichDay;
      content.latLong = nearByPlacesModal.location;
      model = [];
      model.add(content);
    } else {
      bool isMatched = false;
      model.forEach((element) {
        if (element.placeId == nearByPlacesModal.place_id &&
            element.whichDay == whichDay) {
          element.hours = hours;
          isMatched = true;
        }
      });
      if (!isMatched) {
        var content = Content();
        content.name = nearByPlacesModal.name;
        content.rating = nearByPlacesModal.rating;
        content.placeId = nearByPlacesModal.place_id;
        content.image = nearByPlacesModal.icon;
        content.hours = hours;
        content.whichDay = whichDay;
        content.latLong = nearByPlacesModal.location;
        model.add(content);
      }
    }
    widget.provider.trip!.content = model;
    widget.provider.notifyListeners();
    print(model);
  }

  Widget loadInList() {
    if (modals == null || modals!.length < 1) {
      return Container();
    }

    return ListView.builder(
      itemCount: modals!.length, // Number of items to display
      itemBuilder: (BuildContext context, int index) {
        return Container(
          color: AppColors.white,
          margin: EdgeInsets.only(top: 4, bottom: 4),
          padding: EdgeInsets.all(8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.network(
                modals![index].icon ??
                    "https://img.freepik.com/free-photo/abstract-grunge-decorative-relief-navy-blue-stucco-wall-texture-wide-angle-rough-colored-background_1258-28311.jpg?w=2000&t=st=1681412214~exp=1681412814~hmac=17fe5554ebc72cbecef9dbb6a6158eb7107188bf2071064db35c51e02d6bb0c8",
                width: 48,
                height: 48,
                fit: BoxFit.cover,
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${modals![index].name}',
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
                          '${modals![index].rating}',
                        ),
                        const SizedBox(width: 8),
                        RatingView(
                          max: 5,
                          initial: modals![index].rating,
                        ),
                        Expanded(
                          child: Container(
                            alignment: Alignment.centerRight,
                            child: GestureDetector(
                              onTap: () {
                                HourSpentDialog.show(
                                  context,
                                  true,
                                  (int value) {
                                    String? result =
                                        multipleDayCalculateSpendingHour(
                                            modals![index], index, value);
                                    if (result != null) {
                                      Commons.showMessage(context, result);
                                      return;
                                    }
                                    addItem(modals![index], index, value);
                                  },
                                );
                              },
                              child: const Icon(
                                Icons.add_circle_outlined,
                                color: AppColors.grey,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.blue.withOpacity(0.1),
      child: modals == null || modals!.isEmpty
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              color: AppColors.orangeLight,
              child: loadInList(),
            ),
    );
  }
}

class RatingView extends StatelessWidget {
  final int max;
  final double? initial;

  const RatingView({
    Key? key,
    required this.max,
    this.initial = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RatingBar.builder(
      initialRating: initial!,
      minRating: 1,
      direction: Axis.horizontal,
      allowHalfRating: true,
      itemSize: 14,
      itemCount: max,
      itemPadding: const EdgeInsets.symmetric(horizontal: 1.0),
      itemBuilder: (context, _) => const Icon(
        Icons.star,
        color: Colors.amber,
        size: 8,
      ),
      onRatingUpdate: (rating) {
        print(rating);
      },
    );
  }
}
