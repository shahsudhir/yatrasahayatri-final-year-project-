import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yatrasahayatri/models/TripModel.dart';
import 'package:yatrasahayatri/providers/AppProvider.dart';
import 'package:yatrasahayatri/uis/travel_plan/dialogs/NearByPlacesDialog.dart';
import 'package:yatrasahayatri/utils/Commons.dart';

class TripListsView extends StatelessWidget {
  final int index;

  const TripListsView({
    Key? key,
    required this.index,
  }) : super(key: key);

  Widget loadInList() {
    return Consumer<AppProvider>(
      builder: (context, myModel, child) {
        var modals = myModel.trip!.content;
        if (modals == null || modals.length < 1) {
          return Center(
            child: Text("Add your Trip plan"),
          );
        }

        List<Content>? contents = modals
            .where((element) => element.whichDay == index)
            .toList();

        if (contents == null || contents.length < 1) {
          return Center(
            child: Text("Add your Trip plan"),
          );
        }

        return ListView.builder(
          itemCount: contents.length, // Number of items to display
          itemBuilder: (BuildContext context, int index) {
            return Container(
              color: AppColors.white,
              margin: EdgeInsets.only(top: 4, bottom: 4),
              padding: EdgeInsets.all(8),
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
                              // HourSpentDialog.show(
                              //   context,
                              //   true,
                              //       (int value) {
                              //     addItem(modals![index], index, value);
                              //   },
                              // );
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
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
