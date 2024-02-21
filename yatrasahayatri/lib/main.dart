import 'package:flutter/material.dart';
import 'package:yatrasahayatri/animation/CustomAnimation.dart';
import 'package:yatrasahayatri/uis/DashboardPage.dart';
import 'package:yatrasahayatri/uis/auth/LoginPage.dart';
import 'package:yatrasahayatri/providers/AppProvider.dart';
import 'package:provider/provider.dart';
import 'package:yatrasahayatri/uis/splash/SplashPage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    EasyLoadingView.instance();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.white,
          ),
        ),
        home: const SplashPage(),
        builder: EasyLoadingView.init(),
      ),
    );
  }
}

//EasyLoadingView.show(message: 'Loading...');
//EasyLoadingView.dismiss();
