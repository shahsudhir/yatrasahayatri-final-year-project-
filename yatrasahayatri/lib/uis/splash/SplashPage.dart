import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:yatrasahayatri/Routes.dart';
import 'package:yatrasahayatri/models/UserModel.dart';
import 'package:yatrasahayatri/providers/AppProvider.dart';
import 'package:yatrasahayatri/services/local/LocalStorage.dart';
import 'package:yatrasahayatri/utils/Commons.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  AppProvider? provider;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => init());
  }

  Future init() async {
    UserModel? model = await LocalStorage.getAuthCredentials();
    Future.delayed(const Duration(seconds: 2), () {
      if (model == null) {
        Routes.gotoLogin(context);
      } else {
        provider!.user = model;
        Routes.gotoDashboard(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<AppProvider>(context);

    return Scaffold(
      body: SafeArea(
        child: Container(
            color: AppColors.orange,
            child: Column(
              children: [
                Stack(
                  children: [
                    Container(
                      color: AppColors.orange,
                      height: 350,
                      child: SvgPicture.asset(
                        "images/wave8.svg",
                        fit: BoxFit.fill,
                      ),
                    ),
                  ],
                ),
                Container(
                  color: AppColors.orange,
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            "images/ic_logo_detail.png",
                            height: 200,
                            width: 300,
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            )),
      ),
    );
  }
}
