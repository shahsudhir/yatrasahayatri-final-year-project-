//MultipleDayPlanView

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yatrasahayatri/models/TripModel.dart';
import 'package:yatrasahayatri/providers/AppProvider.dart';
import 'package:yatrasahayatri/uis/travel_plan/dialogs/HourSpentDialog.dart';
import 'package:yatrasahayatri/uis/travel_plan/dialogs/NearByPlacesDialog.dart';
import 'package:yatrasahayatri/utils/Commons.dart';

class MultipleDayPlanView extends StatefulWidget {
  final Widget tab;
  final AppProvider? provider;
  final int index;

  final bool showTripPlan;
  TripModel? models;

  MultipleDayPlanView({
    Key? key,
    required this.tab,
    required this.provider,
    required this.index,
    required this.showTripPlan,
    TripModel? models,
  }) : super(key: key) {
    this.models = models;
  }

  @override
  State<MultipleDayPlanView> createState() => _DayWiseViewState();
}

class _DayWiseViewState extends State<MultipleDayPlanView> {
  @override
  void initState() {
    super.initState();
    if (!widget.showTripPlan) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) {
          if (widget.provider!.trip!.daysContent![widget.index].maxHours == 0) {
            HourSpentDialog.show(
              context,
              false,
              (int value) {
                widget.provider!.trip!.daysContent![widget.index].maxHours =
                    value;
              },
            );
          }
        },
      );
    }
  }

  Widget loadInList(List<Content> contents, IconData icon) {
    return ListView.builder(
      itemCount: contents.length, // Number of items to display
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
                contents[index].image ??
                    "https://img.freepik.com/free-photo/abstract-grunge-decorative-relief-navy-blue-stucco-wall-texture-wide-angle-rough-colored-background_1258-28311.jpg?w=2000&t=st=1681412214~exp=1681412814~hmac=17fe5554ebc72cbecef9dbb6a6158eb7107188bf2071064db35c51e02d6bb0c8",
                width: 68,
                height: 68,
                fit: BoxFit.cover,
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${contents[index].name}',
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
                          '${contents[index].rating}',
                        ),
                        const SizedBox(width: 8),
                        RatingView(
                          max: 5,
                          initial: contents[index].rating,
                        ),
                        Expanded(
                          child: Container(
                            alignment: Alignment.centerRight,
                            child: GestureDetector(
                              onTap: () {
                                show(
                                  context,
                                  contents[index],
                                  (trip) {
                                    if (!widget.showTripPlan) {
                                      //contents.remove(trip);
                                      widget.provider!.trip!.content!
                                          .remove(trip);
                                    }
                                    Navigator.pop(context);
                                    setState(() {});
                                  },
                                );
                              },
                              child: Icon(
                                icon,
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

  Widget loadAddInList() {
    return Consumer<AppProvider>(
      builder: (context, myModel, child) {
        var modals = myModel.trip!.content;
        if (modals == null || modals.length < 1) {
          return Center(
            child: Text("Add your Trip plan"),
          );
        }

        List<Content>? contents = modals
            .where((element) => element.whichDay == widget.index + 1)
            .toList();

        if (contents == null || contents.length < 1) {
          return Center(
            child: Text("Add your Trip plan"),
          );
        }

        return loadInList(
          contents,
          Icons.cancel,
        );
      },
    );
  }

  Widget loadViewInList() {
    var modals = widget.models!.content;
    if (modals == null || modals.length < 1) {
      return Center(
        child: Text("Add your Trip plan"),
      );
    }

    List<Content>? contents = modals
        .where((element) => element.whichDay == widget.index + 1)
        .toList();

    if (contents == null || contents.length < 1) {
      return Center(
        child: Text("Add your Trip plan"),
      );
    }

    return loadInList(
      contents,
      Icons.route_outlined,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.orangeLight,
      child: widget.showTripPlan ? loadViewInList() : loadAddInList(),
    );
  }
}

show(
  BuildContext context,
  Content trip,
  Function(Content) callback,
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
              callback(trip);
            },
            child: Text('OK'),
          ),
        ],
      );
    },
  );
}
