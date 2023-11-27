import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:happifeet_client_app/screens/splash_screen.dart';

void main() async{

  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  runApp(
      EasyLocalization(
          supportedLocales: [
            Locale('en'),
            Locale('es'),
            Locale('ru'),
            Locale('zh'),
          ],
  path: 'assets/i18n',
  child: const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();


  // This widget is the root of your application.



}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HappiFeet Client App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}



