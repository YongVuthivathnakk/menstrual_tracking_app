import 'package:flutter/material.dart';
//import 'package:menstrual_tracking_app/app.dart';
import 'package:menstrual_tracking_app/ui/pages/start_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flow App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: "Nunito",
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xff9A0002),
          brightness: Brightness.light,
          surface: Colors.white,
        ),
        scaffoldBackgroundColor: const Color(0xffFAE5E4),
      ),
      home: StartPage(),
    );
  }
}
