import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yatrasahayatri/Routes.dart';
import 'package:yatrasahayatri/animation/fade_animation.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:yatrasahayatri/models/UserModel.dart';
import 'package:yatrasahayatri/providers/AppProvider.dart';
import 'package:yatrasahayatri/services/local/LocalStorage.dart';
import 'package:yatrasahayatri/services/remote/AuthApi.dart';
import 'package:yatrasahayatri/utils/Commons.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  AppProvider? provider;
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  Future<void> validation() async {
    if (email.text.isEmpty ||
        !EmailValidator.validate(email.text.toString().trim())) {
      Commons.showMessage(context, "Please Enter valid email address");
    } else if (password.text.isEmpty || password.text.length < 3) {
      Commons.showMessage(
          context, "Please Enter password greater than 3 letters");
    } else {
      UserModel? model = await AuthApi.login(
        email: email.text.toString().trim(),
        password: password.text.toString().trim(),
        context: context,
      );
      if (model == null) {
        Commons.showMessage(
          context,
          "Could not login to app. Please contact to Support team.",
        );
      } else if (!model.success!) {
        Commons.showMessage(context, "${model.message}");
      } else {
        provider?.user = model;
        LocalStorage.saveAuthCredentials(model);
        Commons.showMessage(context, "${model.message}");
        Routes.gotoDashboard(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<AppProvider>(context);
    var wid = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: AppColors.orange,
      body: LayoutBuilder(
        builder: (context, constraint) {
          return SingleChildScrollView(
            child: Column(
              children: [
                Stack(
                  children: [
                    Container(
                      color: AppColors.orange,
                      width: wid,
                      height: 350,
                      child: SvgPicture.asset(
                        "images/wave8.svg",
                        fit: BoxFit.fill,
                      ),
                    ),
                    const Positioned(
                      top: 100,
                      left: 45,
                      child: FadeAnimation(
                        2,
                        Text(
                          "Yatrasahayatri",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 38,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 2,
                              fontFamily: "Lobster"),
                        ),
                      ),
                    )
                  ],
                ),
                Container(
                  color: AppColors.orange,
                  child: Column(
                    children: [
                      FadeAnimation(
                        2,
                        Container(
                            width: double.infinity,
                            height: 240,
                            margin: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 20),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 5),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    const Icon(Icons.email_outlined),
                                    Expanded(
                                      child: Container(
                                        margin: const EdgeInsets.only(left: 10),
                                        child: TextFormField(
                                          controller: email,
                                          maxLines: 1,
                                          decoration: const InputDecoration(
                                            label: Text(" E-mail ..."),
                                            border: InputBorder.none,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const Divider(
                                  height: 5,
                                  thickness: 3,
                                  indent: 50,
                                  endIndent: 50,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    const Icon(Icons.password_outlined),
                                    Expanded(
                                      child: Container(
                                        margin: const EdgeInsets.only(left: 10),
                                        child: TextFormField(
                                          controller: password,
                                          maxLines: 1,
                                          obscureText: true,
                                          decoration: const InputDecoration(
                                            label: Text(" Password ..."),
                                            border: InputBorder.none,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            )),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      FadeAnimation(
                        2,
                        Container(
                          margin: const EdgeInsets.only(left: 22, right: 22),
                          child: ElevatedButton(
                            onPressed: () {
                              validation();
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
                                width: wid - 20,
                                height: 50,
                                alignment: Alignment.center,
                                child: const Text(
                                  'Login',
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
                      Container(
                        margin: const EdgeInsets.only(top: 30),
                        child: GestureDetector(
                          onTap: () {
                            Routes.gotoSignUp(context);
                          },
                          child: const Text(
                            "SingUp if don't have account",
                            style: TextStyle(
                              color: Colors.white,
                              letterSpacing: 2,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
