import 'package:flutter/material.dart';
import 'package:yatrasahayatri/Routes.dart';
import 'package:yatrasahayatri/utils/Commons.dart';

class HourSpentDialog {
  static show(
    BuildContext context,
    bool showCancelButton,
    Function(int) callback,
  ) {
    TextEditingController controller = TextEditingController();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ), //this right here
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Tour Time',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.blue,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Enter, how hour you want to spend',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 28),
                TextField(
                  controller: controller,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 0.0,
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
                    hintText: "Time 4 (Hours)",
                  ),
                ),
                const SizedBox(height: 28),
                Row(
                  children: [
                    Expanded(
                      child: showCancelButton
                          ? ElevatedButton(
                              onPressed: () {
                                if (controller.text.isEmpty) {
                                  Commons.showMessage(
                                    context,
                                    "Please enter how much time you want to spend",
                                  );
                                } else {
                                  int value = int.parse(
                                    controller.text.toString().trim(),
                                  );
                                  if (value > 24.0) {
                                    Commons.showMessage(
                                      context,
                                      "Time must be below 24 hrs",
                                    );
                                    return;
                                  }
                                  callback(value);
                                  Routes.gotoBack(context);
                                }
                              },
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        AppColors.white),
                              ),
                              child: const Text(
                                "Cancel",
                                style: TextStyle(color: AppColors.orange),
                              ),
                              //color: const Color(0xFF1BC0C5),
                            )
                          : Container(),
                    ),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          if (controller.text.isEmpty) {
                            Commons.showMessage(
                              context,
                              "Please enter how much time you want to spend",
                            );
                          } else {
                            int value = int.parse(
                              controller.text.toString().trim(),
                            );
                            if(value > 24.0){
                              Commons.showMessage(
                                context,
                                "Time must be below 24 hrs",
                              );
                              return;
                            }
                            callback(value);
                            Routes.gotoBack(context);
                          }
                        },
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all<Color>(AppColors.blue),
                        ),
                        child: const Text(
                          "Proceed",
                          style: TextStyle(color: AppColors.white),
                        ),
                        //color: const Color(0xFF1BC0C5),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
