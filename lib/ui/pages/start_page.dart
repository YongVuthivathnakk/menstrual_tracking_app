import 'package:flutter/material.dart';
import 'package:menstrual_tracking_app/services/menstrual_log_database.dart';
import 'package:menstrual_tracking_app/ui/pages/form_page.dart';
import 'package:menstrual_tracking_app/ui/pages/home_page.dart';

class StartPage extends StatefulWidget {
  const StartPage({super.key});

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  Future<void> _onStart() async {
    final logs = await MenstrualLogDatabase.instance.getPeriodLogs();

    if (logs.isEmpty) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (BuildContext context) => FormPage()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (BuildContext context) => HomePage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 200,
          children: [
            Center(child: Image.asset('assets/images/Logo.png')),
            SizedBox(
              width: 250,
              height: 50,
              child: TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Color(0xff9A0002),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: _onStart,
                child: Text(
                  "Get Started",
                  style: TextStyle(fontSize: 24, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
