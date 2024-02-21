import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yatrasahayatri/Routes.dart';
import 'package:yatrasahayatri/models/TripModel.dart';
import 'package:yatrasahayatri/models/TripPlanType.dart';
import 'package:yatrasahayatri/providers/AppProvider.dart';
import 'package:yatrasahayatri/uis/travel_plan/plans/MultipleDayPlanView.dart';
import 'package:yatrasahayatri/uis/travel_plan/plans/SingleDayPlanView.dart';
import 'package:yatrasahayatri/uis/travel_plan/dialogs/NearByPlacesDialog.dart';
import 'package:yatrasahayatri/utils/Commons.dart';

class YourTravelPlanPage extends StatefulWidget {
  final bool showTripPlan;
  TripModel? models;

  YourTravelPlanPage({
    Key? key,
    required this.showTripPlan,
    TripModel? models,
  }) : super(key: key) {
    this.models = models;
  }

  @override
  State<YourTravelPlanPage> createState() => _YourTravelPlanPageState();
}

class _YourTravelPlanPageState extends State<YourTravelPlanPage>
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
        List<DayContent>? daysContent = [];
        if (widget.showTripPlan) {
          daysContent = widget.models?.daysContent;
        } else {
          daysContent = provider?.trip?.daysContent;
        }
        daysContent?.forEach((element) {
          String day = element.days ?? "";
          myTabs!.add(SizedBox(
            key: Key("Day ${day}"),
            child: Tab(
              text: "Day ${day}",
              key: Key("Day ${day}"),
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

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<AppProvider>(context);

    TripPlanType type = TripPlanType.NONE;
    if (widget.showTripPlan) {
      type = widget.models!.type!;
    } else {
      type = provider!.trip!.type!;
    }

    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Routes.gotoBack(context);
          },
          child: const Icon(Icons.arrow_back),
        ),
        backgroundColor: AppColors.blue,
        centerTitle: true,
        title: Text(
          widget.showTripPlan
              ? "${widget.models!.placeName}"
              : "Your Travel Plan",
          style: TextStyle(
            color: AppColors.white,
            fontSize: 18,
          ),
        ),
        actions: [
          widget.showTripPlan
              ? Container()
              : Container(
                  margin: const EdgeInsets.only(right: 16),
                  child: GestureDetector(
                    onTap: () {
                      NearByPlacesDialog.show(
                        context,
                        "Plan For Day ${_tabController.index + 1}",
                        _tabController.index + 1,
                          TripPlanType.OUT_STATION,
                      );
                    },
                    child: const Icon(
                      Icons.add,
                      color: AppColors.white,
                    ),
                  ),
                ),
        ],
        bottom: type == TripPlanType.OUT_STATION && myTabs != null
            ? TabBar(
                controller: _tabController,
                tabs: myTabs!,
                isScrollable: true,
              )
            : null,
      ),
      body: Stack(
        children: [
          type == TripPlanType.OUT_STATION
              ? GestureDetector(
                  onHorizontalDragUpdate: (details) {},
                  child: myTabs != null
                      ? TabBarView(
                          controller: _tabController,
                          children: tabUis(),
                        )
                      : Container(),
                )
              : SingleDayPlanView(
                  showTripPlan: widget.showTripPlan,
                  models: widget.models,
                ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              margin: EdgeInsets.all(16),
              child: ElevatedButton(
                onPressed: () {
                  Routes.gotoMapView(
                    context,
                    true,
                    widget.models,
                    widget.showTripPlan,
                  );
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
                    height: 50,
                    alignment: Alignment.center,
                    child: Text(
                      widget.showTripPlan ? "View" : 'Proceed',
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
          ),
        ],
      ),
    );
  }

  List<Widget> tabUis() {
    List<Widget> views = [];
    if (myTabs != null) {
      for (int i = 0; i < myTabs!.length; i++) {
        views.add(MultipleDayPlanView(
          tab: myTabs![i],
          provider: provider,
          index: i,
          showTripPlan: widget.showTripPlan,
          models: widget.models,
        ));
      }
    }
    return views.toList();
  }
}

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return Container(); // Empty container
  }

  @override
  Size get preferredSize => Size.fromHeight(0);
}
