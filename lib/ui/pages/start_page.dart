import 'package:flutter/material.dart';
import 'package:menstrual_tracking_app/ui/pages/home_page.dart';

class StartPage extends StatelessWidget {
  const StartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 200,
          children: [
            Center(
              child: Image.asset('assets/images/Logo.png'),
            ),
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
                onPressed: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) =>
                      HomePage(),
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
