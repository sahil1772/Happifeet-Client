import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../screens/Dashboard/dashboard.dart';
import '../screens/Manage/manage.dart';
import '../screens/Profile/Profile.dart';
import '../screens/Reports/Reports.dart';

class BottomNavigationHappiFeet extends StatefulWidget{
  @override
  State<BottomNavigationHappiFeet> createState() => _BottomNavigationHappiFeetState();

  goToBottomNavigation(BuildContext context){
    Navigator.push(context, MaterialPageRoute(builder: (_) => BottomNavigationHappiFeet()));
  }


}

class _BottomNavigationHappiFeetState extends State<BottomNavigationHappiFeet>{
  late PersistentTabController _controller;

  @override
  void initState() {
    _controller = PersistentTabController(initialIndex: 0);
    setBoolForLogIn();
    super.initState();
  }

  void setBoolForLogIn() async {
    /** update checkIfLoggedIn value in shared pref   **/
    SharedPreferences prefs =  await SharedPreferences.getInstance();
    prefs.setBool('loggedIn', true);
  }

  List<Widget> _buildScreens() {
    return [
      const DashboardWidget(),
      const ManageWidget(),
      const ReportsWidget(),
      const ProfileWidget(),

    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        title: 'Dashboard',
        activeColorPrimary: CupertinoColors.destructiveRed,
        inactiveColorPrimary: CupertinoColors.inactiveGray,
        // textStyle: TextStyle(color: ColorParser().hexToColor(SharedPref().getCityTheme().body_text_color!)),
        icon: SvgPicture.asset("assets/images/bottomSheet/dashboard.svg",
          colorFilter: const ColorFilter.mode(Colors.red, BlendMode.srcIn),),
        inactiveIcon:  SvgPicture.asset("assets/images/bottomSheet/dashboard.svg",
          colorFilter: const ColorFilter.mode(Colors.grey, BlendMode.srcIn),),
        // activeColorPrimary: Colors.red,
        // activeColorSecondary: Colors.lightBlue,
      ),
      PersistentBottomNavBarItem(
        title: 'Manage',
        activeColorPrimary: CupertinoColors.destructiveRed,
        inactiveColorPrimary: CupertinoColors.inactiveGray,
        // textStyle: TextStyle(color: ColorParser().hexToColor(SharedPref().getCityTheme().body_text_color!)),
        icon: SvgPicture.asset("assets/images/bottomSheet/manage.svg",
          colorFilter: const ColorFilter.mode(Colors.red, BlendMode.srcIn),),
        inactiveIcon:  SvgPicture.asset("assets/images/bottomSheet/manage.svg",
          colorFilter: const ColorFilter.mode(Colors.grey, BlendMode.srcIn),),
        // activeColorPrimary: Colors.red,
        // activeColorSecondary: Colors.lightBlue,
      ),
      PersistentBottomNavBarItem(
        title: 'Reports',
        activeColorPrimary: CupertinoColors.destructiveRed,
        inactiveColorPrimary: CupertinoColors.inactiveGray,
        // textStyle: TextStyle(color: ColorParser().hexToColor(SharedPref().getCityTheme().body_text_color!)),
        icon: SvgPicture.asset("assets/images/bottomSheet/report.svg",
          colorFilter: const ColorFilter.mode(Colors.red, BlendMode.srcIn),),
        inactiveIcon:  SvgPicture.asset("assets/images/bottomSheet/report.svg",
          colorFilter: const ColorFilter.mode(Colors.grey, BlendMode.srcIn),),
        // activeColorPrimary: Colors.red,
        // activeColorSecondary: Colors.lightBlue,
      ),
      PersistentBottomNavBarItem(
        title: 'Profile',
        activeColorPrimary: CupertinoColors.destructiveRed,
        inactiveColorPrimary: CupertinoColors.inactiveGray,
        // textStyle: TextStyle(color: ColorParser().hexToColor(SharedPref().getCityTheme().body_text_color!)),
        icon: SvgPicture.asset("assets/images/bottomSheet/profile.svg",
          colorFilter: const ColorFilter.mode(Colors.red, BlendMode.srcIn),),
        inactiveIcon:  SvgPicture.asset("assets/images/bottomSheet/profile.svg",
          colorFilter: const ColorFilter.mode(Colors.grey, BlendMode.srcIn),),
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
              color: Colors.grey.shade400,
              spreadRadius: 1,
              blurRadius: 15
          ),
        ],
      ),
      navBarStyle: NavBarStyle.style6,
    );
  }
}