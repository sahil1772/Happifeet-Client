import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:happifeet_client_app/storage/runtime_storage.dart';
import 'package:happifeet_client_app/storage/shared_preferences.dart';
import 'package:happifeet_client_app/utils/ColorParser.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../screens/Dashboard/dashboard.dart';
import '../screens/Manage/manage.dart';
import '../screens/Profile/Profile.dart';
import '../screens/Reports/Reports.dart';

class BottomNavigationHappiFeet extends StatefulWidget {
  BottomNavigationHappiFeet({super.key});

  @override
  State<BottomNavigationHappiFeet> createState() =>
      _BottomNavigationHappiFeetState();

  goToBottomNavigation(BuildContext context) {
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (_) => BottomNavigationHappiFeet()));
  }
}

class _BottomNavigationHappiFeetState extends State<BottomNavigationHappiFeet> {
  late PersistentTabController _controller;
  String? userType = "";

  @override
  void initState() {
    // log("USER DATA --> ${widget.userData!.toJson()}");
    _controller = PersistentTabController(initialIndex: 0);


    setBoolForLogIn();

    SharedPref.instance.getClientType().then((value) {
      userType = value;
      log("USER TYPE ==> ", error: userType);
      setState(() {});
    });

    /** Display with status and navigation bar **/
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.initState();
  }

  void setBoolForLogIn() async {
    /** update checkIfLoggedIn value in shared pref   **/
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('loggedIn', true);
  }

  List<Widget> _buildScreens() {
    return [
      const DashboardWidget(),
      if (userType == "S") ManageWidget(),
      ReportsWidget(),
      ProfileWidget(),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        title: 'Dashboard',
        activeColorPrimary: ColorParser().hexToColor(
            RuntimeStorage.instance.clientTheme!.top_title_background_color!),
        inactiveColorPrimary: CupertinoColors.inactiveGray,
        // textStyle: TextStyle(color: ColorParser().hexToColor(SharedPref().getCityTheme().body_text_color!)),
        icon: SvgPicture.asset(
          "assets/images/bottomSheet/dashboard.svg",
          colorFilter: ColorFilter.mode(
              ColorParser().hexToColor(RuntimeStorage
                  .instance.clientTheme!.top_title_background_color!),
              BlendMode.srcIn),
        ),
        inactiveIcon: SvgPicture.asset(
          "assets/images/bottomSheet/dashboard.svg",
          colorFilter: const ColorFilter.mode(Colors.grey, BlendMode.srcIn),
        ),
        // activeColorPrimary: Colors.red,
        // activeColorSecondary: Colors.lightBlue,
      ),
      if (userType == "S")
        PersistentBottomNavBarItem(
          title: 'Manage',
          activeColorPrimary: ColorParser().hexToColor(
              RuntimeStorage.instance.clientTheme!.top_title_background_color!),
          inactiveColorPrimary: CupertinoColors.inactiveGray,
          // textStyle: TextStyle(color: ColorParser().hexToColor(SharedPref().getCityTheme().body_text_color!)),
          icon: SvgPicture.asset(
            "assets/images/bottomSheet/manage.svg",
            colorFilter: ColorFilter.mode(
                ColorParser().hexToColor(RuntimeStorage
                    .instance.clientTheme!.top_title_background_color!),
                BlendMode.srcIn),
          ),
          inactiveIcon: SvgPicture.asset(
            "assets/images/bottomSheet/manage.svg",
            colorFilter: const ColorFilter.mode(Colors.grey, BlendMode.srcIn),
          ),
          // activeColorPrimary: Colors.red,
          // activeColorSecondary: Colors.lightBlue,
        ),
      PersistentBottomNavBarItem(
        title: 'Reports',
        activeColorPrimary: ColorParser().hexToColor(
            RuntimeStorage.instance.clientTheme!.top_title_background_color!),
        inactiveColorPrimary: CupertinoColors.inactiveGray,
        // textStyle: TextStyle(color: ColorParser().hexToColor(SharedPref().getCityTheme().body_text_color!)),
        icon: SvgPicture.asset(
          "assets/images/bottomSheet/report.svg",
          colorFilter: ColorFilter.mode(
              ColorParser().hexToColor(RuntimeStorage
                  .instance.clientTheme!.top_title_background_color!),
              BlendMode.srcIn),
        ),
        inactiveIcon: SvgPicture.asset(
          "assets/images/bottomSheet/report.svg",
          colorFilter: const ColorFilter.mode(Colors.grey, BlendMode.srcIn),
        ),
        // activeColorPrimary: Colors.red,
        // activeColorSecondary: Colors.lightBlue,
      ),
      PersistentBottomNavBarItem(
        title: 'Profile',
        activeColorPrimary: ColorParser().hexToColor(
            RuntimeStorage.instance.clientTheme!.top_title_background_color!),
        inactiveColorPrimary: CupertinoColors.inactiveGray,
        // textStyle: TextStyle(color: ColorParser().hexToColor(SharedPref().getCityTheme().body_text_color!)),
        icon: SvgPicture.asset(
          "assets/images/bottomSheet/profile.svg",
          colorFilter: ColorFilter.mode(
              ColorParser().hexToColor(RuntimeStorage
                  .instance.clientTheme!.top_title_background_color!),
              BlendMode.srcIn),
        ),
        inactiveIcon: SvgPicture.asset(
          "assets/images/bottomSheet/profile.svg",
          colorFilter: const ColorFilter.mode(Colors.grey, BlendMode.srcIn),
        ),
        // activeColorPrimary: Colors.red,
        // activeColorSecondary: Colors.lightBlue,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      context,
      controller: _controller,
      screens: _buildScreens(),
      items: _navBarsItems(),
      backgroundColor: Colors.white,
      decoration: NavBarDecoration(
        // borderRadius: BorderRadius.circular(10.0),
        colorBehindNavBar: Colors.white,
        boxShadow: [
          BoxShadow(
              color: Colors.grey.shade400, spreadRadius: 1, blurRadius: 15),
        ],
      ),
      navBarStyle: NavBarStyle.style6,
    );
  }
}
