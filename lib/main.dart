import 'package:flutter/material.dart';
import 'package:menstrual_tracking_app/ui/pages/start_page.dart';
import 'package:menstrual_tracking_app/ui/theme_data.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Voat App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: "Nunito",
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppTheme.primary,
          brightness: Brightness.light,
          surface: Colors.white,
        ),
        scaffoldBackgroundColor: AppTheme.backgroundColor,
      ),
      home: StartPage(),
    );
  }
}
