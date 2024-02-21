import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:provider/provider.dart';
import 'package:yatrasahayatri/models/TripModel.dart';
import 'package:yatrasahayatri/providers/AppProvider.dart';
import 'package:yatrasahayatri/services/remote/TripApi.dart';
import 'package:yatrasahayatri/uis/home/HomePage.dart';
import 'package:yatrasahayatri/uis/profile/ProfilePage.dart';
import 'package:yatrasahayatri/uis/travel_plan/TravelPlanListingPage.dart';
import 'package:yatrasahayatri/utils/Commons.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  AppProvider? provider;

  final PersistentTabController _controller =
      PersistentTabController(initialIndex: 0);

  List<Widget> _buildScreens() {
    return [
      const HomePage(),
      const TravelPlanListingPage(),
      const ProfilePage(),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: const Icon(
          Icons.home,
          color: AppColors.white,
        ),
        title: "Home",
        textStyle: const TextStyle(
          color: AppColors.white,
        ),
        activeColorPrimary: AppColors.white,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(
          Icons.assignment,
          color: AppColors.white,
        ),
        title: "Travel Plan",
        textStyle: const TextStyle(
          color: AppColors.white,
        ),
        activeColorPrimary: AppColors.white,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.person),
        title: "Profile",
        activeColorPrimary: AppColors.white,
      ),
    ];
  }



  @override
  Widget build(BuildContext context) {
    provider = Provider.of<AppProvider>(context);

    return PersistentTabView(
      context,
      controller: _controller,
      screens: _buildScreens(),
      items: _navBarsItems(),
      confineInSafeArea: true,
      backgroundColor: AppColors.blue,
      handleAndroidBackButtonPress: true,
      resizeToAvoidBottomInset: true,
      stateManagement: true,
      hideNavigationBarWhenKeyboardShows: true,
      popAllScreensOnTapOfSelectedTab: true,
      popActionScreens: PopActionScreensType.all,
      itemAnimationProperties: const ItemAnimationProperties(
        duration: Duration(milliseconds: 200),
        curve: Curves.ease,
      ),
      screenTransitionAnimation: const ScreenTransitionAnimation(
        animateTabTransition: true,
        curve: Curves.ease,
        duration: Duration(milliseconds: 200),
      ),
      navBarStyle: NavBarStyle.style1,
    );
  }
}
