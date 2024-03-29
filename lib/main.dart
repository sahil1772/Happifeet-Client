import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:happifeet_client_app/screens/splash_screen.dart';
import 'package:happifeet_client_app/storage/shared_preferences.dart';
import 'package:happifeet_client_app/utils/ColorParser.dart';
import 'package:loader_overlay/loader_overlay.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  runApp(EasyLocalization(supportedLocales: const [
    Locale('en'),
    Locale('es'),
    Locale('ru'),
    Locale('zh'),
  ], path: 'assets/i18n', child: const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();

// This widget is the root of your application.
}

class _MyAppState extends State<MyApp> {

  String? hexColor;

  @override
  void initState() {
    // TODO: implement initState




    SharedPref.instance.getCityTheme().then((value) {
      hexColor = value.top_title_background_color;
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HappiFeet Client App',
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      debugShowCheckedModeBanner: false,
      builder: (context, child) {
        return MediaQuery(data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(0.9)), child: child!);
      },
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
        canvasColor: Colors.transparent,
        colorScheme: ColorScheme.fromSeed(
            seedColor: from(hexColor == null ? Color(0xff49AC43) : ColorParser().hexToColor(hexColor!))),
        useMaterial3: true,
      ),

      home: const SplashScreen(),
    );
  }

  static MaterialColor from(Color color) {
    return MaterialColor(color.value, {
      50: tintColor(color, 0.9),
      100: tintColor(color, 0.8),
      200: tintColor(color, 0.6),
      300: tintColor(color, 0.4),
      400: tintColor(color, 0.2),
      500: color,
      600: shadeColor(color, 0.1),
      700: shadeColor(color, 0.2),
      800: shadeColor(color, 0.3),
      900: shadeColor(color, 0.4),
    });
  }

  static int tintValue(int value, double factor) =>
      max(0, min((value + ((255 - value) * factor)).round(), 255));

  static Color tintColor(Color color, double factor) => Color.fromRGBO(
      tintValue(color.red, factor),
      tintValue(color.green, factor),
      tintValue(color.blue, factor),
      1);

  static int shadeValue(int value, double factor) =>
      max(0, min(value - (value * factor).round(), 255));

  static Color shadeColor(Color color, double factor) => Color.fromRGBO(
      shadeValue(color.red, factor),
      shadeValue(color.green, factor),
      shadeValue(color.blue, factor),
      1);
}
