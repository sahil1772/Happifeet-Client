import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../storage/shared_preferences.dart';



class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    // return SvgPicture.asset(
    //   "assets/images/splashScreen/splash_screen.svg",
    // );
    // return Image.asset("assets/images/splashScreen/splash_screen_png.png",fit: BoxFit.fill,);
    return SvgPicture.asset("assets/images/splashScreen/splash_screen.svg",fit: BoxFit.fill,);
  }

  @override
  void initState() {
    super.initState();
    init();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);
    context.setLocale(const Locale('en'));

  }

  Future<void> init() async {
    Timer(const Duration(seconds: 2), () {
      SharedPref.instance.checkIfLoggedIn(context);

      // Navigator.pushReplacement(
      //     context,
      //     MaterialPageRoute(
      //       builder: (BuildContext context) => LoginPageWidget(),
      //       // builder: (BuildContext context) => ManageSMTPDetails(),
      //     ));

    });
  }

// Future<void> isUserLoggedIn() async {
//   var available = await inAppUpdateAvailable();
//   if (available) {
//     doImmediateAppUpdate();
//     return;
//   }
//   var isUserLoggedIn = SharedPref.instance.isUserLoggedIn();
//   if (isUserLoggedIn) {
//     NavigationService.instance.gotoDashboard();
//   } else {
//     NavigationService.instance.goToLoginScreen();
//   }
// }
}
