import 'package:flutter/material.dart';
import 'package:menstrual_tracking_app/ui/pages/home_page.dart';
//import 'package:menstrual_tracking_app/ui/widget/cycle_tracker_card.dart';

class StartPage extends StatelessWidget {
  const StartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 200,
          children: [
            Center(
              child: Image.asset('assets/images/Logo.png')
            ),
            SizedBox(
              width: 250,
              height: 50,
              child: TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Color(0xff9A0002),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => 
                    Homepage(),
                  ),
                );
              },
              child: Text(
                "Get Started",               
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                ),
              ),
            ),
            ),
          ],
        ),
      ),
    );
  }
}
