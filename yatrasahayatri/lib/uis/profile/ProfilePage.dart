import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yatrasahayatri/models/UserModel.dart';
import 'package:yatrasahayatri/providers/AppProvider.dart';
import 'package:yatrasahayatri/services/local/LocalStorage.dart';
import 'package:yatrasahayatri/services/remote/AuthApi.dart';
import 'package:yatrasahayatri/utils/Commons.dart';

import 'package:flutter/material.dart';
import 'package:yatrasahayatri/Routes.dart';
import 'package:yatrasahayatri/animation/fade_animation.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:yatrasahayatri/utils/Commons.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  AppProvider? provider;
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  //TextEditingController verifyPassword = TextEditingController();
  TextEditingController fullName = TextEditingController();

  Future<void> validation() async {
    if (fullName.text.isEmpty) {
      Commons.showMessage(context, "Please Enter your name");
    }
    if (!email.text.isEmpty &&
        !EmailValidator.validate(email.text.toString().trim())) {
      Commons.showMessage(context, "Please Enter valid email address");
    }
    if (password.text.isEmpty || password.text.length < 3) {
      Commons.showMessage(
          context, "Please Enter password greater than 3 letters");
    }
    // if (!verifyPassword.text.isEmpty && verifyPassword.text.length < 3 ||
    //     verifyPassword.text.toString().trim() !=
    //         password.text.toString().trim()) {
    //   Commons.showMessage(context, "Could not match your password");
    // }
    else {
      callApi();
    }
  }

  Future<void> callApi() async {
    UserModel? model = await AuthApi.updateUserDetail(
      email: email.text.toString().trim(),
      password: password.text.toString().trim(),
      fullName: fullName.text.toString().trim(),
      model: provider!.user!,
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
      provider?.user?.data?.email = email.text.toString().trim();
      provider?.user?.data?.fullName = fullName.text.toString().trim();
      print("userinfo-----> ${provider?.user?.toJson()}");
      LocalStorage.saveAuthCredentials(provider?.user);
      Commons.showMessage(context, "${model.message}");
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        email.text = provider?.user?.data?.email ?? "";
        fullName.text = provider?.user?.data?.fullName ?? "";
        setState(() {});
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<AppProvider>(context);
    var wid = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: AppColors.orangeLight,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 120),
            Container(
              alignment: Alignment.center,
              child: CircleAvatar(
                radius: 50,
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: const NetworkImage(
                    'https://images.pexels.com/photos/1496372/pexels-photo-1496372.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2',
                    scale: 1.0,
                    headers: {'Cache-Control': 'no-cache'},
                  ),

                  //backgroundColor: Colors.grey,
                  // child: Padding(
                  //   padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                  //   child: Align(
                  //     alignment: Alignment.bottomRight,
                  //     child: Container(
                  //       decoration: const BoxDecoration(
                  //         color: AppColors.green,
                  //         borderRadius:
                  //             BorderRadius.all(Radius.circular(20)),
                  //       ),
                  //       padding: EdgeInsets.all(8),
                  //       child: const Icon(
                  //         Icons.edit,
                  //         color: AppColors.white,
                  //         size: 20.0,
                  //       ),
                  //     ),
                  //   ),
                  // ),
                ),
              ),
            ),
            SizedBox(height: 40),
            Container(
              //color: AppColors.orangeLight,
              child: Column(
                children: [
                  Container(
                      width: double.infinity,
                      height: 300,
                      margin: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 20),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 5),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const Icon(Icons.person_outline),
                              Expanded(
                                child: Container(
                                  margin: const EdgeInsets.only(left: 10),
                                  child: TextFormField(
                                    controller: fullName,
                                    maxLines: 1,
                                    decoration: const InputDecoration(
                                      label: Text(" Full-Name ..."),
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
                          // const Divider(
                          //   height: 5,
                          //   thickness: 3,
                          //   indent: 50,
                          //   endIndent: 50,
                          // ),
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.start,
                          //   children: [
                          //     const Icon(Icons.password_outlined),
                          //     Expanded(
                          //       child: Container(
                          //         margin: const EdgeInsets.only(left: 10),
                          //         child: TextFormField(
                          //           controller: verifyPassword,
                          //           maxLines: 1,
                          //           obscureText: true,
                          //           decoration: const InputDecoration(
                          //             label: Text(" Verify-Password ..."),
                          //             border: InputBorder.none,
                          //           ),
                          //         ),
                          //       ),
                          //     ),
                          //   ],
                          // ),
                        ],
                      )),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    margin:
                        const EdgeInsets.only(left: 22, right: 22, bottom: 40),
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
                            'Update',
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
                ],
              ),
            ),
            const SizedBox(height: 300),
          ],
        ),
      ),
    );
  }
}
