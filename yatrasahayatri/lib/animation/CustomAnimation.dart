import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:yatrasahayatri/animation/Loader2Widget.dart';

class CustomAnimation extends EasyLoadingAnimation {
  @override
  Widget buildWidget(
    Widget child,
    AnimationController controller,
    AlignmentGeometry alignment,
  ) {
    return Opacity(
      opacity: controller.value,
      child: RotationTransition(
        turns: controller,
        child: Loader2Widget(
          radius: 30,
          dotRadius: 5.0,
        ),
      ),
    );
  }
}

class EasyLoadingView {
  static init() {
    return EasyLoading.init();
  }

  static instance() {
    return EasyLoading.instance
      ..displayDuration = const Duration(milliseconds: 2000)
      ..loadingStyle = EasyLoadingStyle.dark
      ..indicatorSize = 65.0
      ..maskType = EasyLoadingMaskType.black
      ..maskColor = Colors.transparent
      ..userInteractions = false
      ..dismissOnTap = false
      ..contentPadding = EdgeInsets.zero
      ..customAnimation = CustomAnimation();
  }

  static show({
    String message = "",
  }) {
    return EasyLoading.show(
      //status: message,
      dismissOnTap: false,
      maskType: EasyLoadingMaskType.custom,
      // indicator: Loader2Widget(
      //   radius: 30,
      //   dotRadius: 5.0,
      // ),
    );
  }

  static dismiss() {
    return EasyLoading.dismiss();
  }
}
