import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yatrasahayatri/models/TripModel.dart';
import 'package:yatrasahayatri/models/UserModel.dart';
import 'package:yatrasahayatri/providers/AppProvider.dart';
import 'package:yatrasahayatri/uis/travel_plan/dialogs/DeleteTripDialog.dart';
import 'package:yatrasahayatri/uis/travel_plan/dialogs/NearByPlacesDialog.dart';
import 'package:yatrasahayatri/utils/Commons.dart';

class SingleDayPlanView extends StatefulWidget {
  final bool showTripPlan;
  TripModel? models;
  Function(TripModel?, int)? callback;

  SingleDayPlanView({
    Key? key,
    required this.showTripPlan,
    TripModel? models,
    this.callback,
  }) : super(key: key) {
    this.models = models;
  }

  @override
  State<SingleDayPlanView> createState() => _SingleDayPlanViewState();
}

class _SingleDayPlanViewState extends State<SingleDayPlanView> {
  Widget loadUI(List<Content> contents, IconData icon) {
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
                                      contents.remove(trip);
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

  @override
  Widget build(BuildContext context) {
    if (widget.showTripPlan) {
      var contents = widget.models!.content;
      if (contents == null || contents.length < 1) {
        return const Center(
          child: Text("Add your Trip plan"),
        );
      }
      return loadUI(
        contents,
        Icons.route_outlined,
      );
    } else {
      return Consumer<AppProvider>(
        builder: (context, myModel, child) {
          var contents = myModel.trip!.content;
          if (contents == null || contents.length < 1) {
            return const Center(
              child: Text("Add your Trip plan"),
            );
          }

          return loadUI(
            contents,
            Icons.cancel,
          );
        },
      );
    }
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
