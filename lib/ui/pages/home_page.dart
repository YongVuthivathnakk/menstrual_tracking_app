import 'package:flutter/material.dart';
import 'package:menstrual_tracking_app/ui/widget/cycle_tracker.dart';

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Image.asset("assets/images/Flow.png")),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: CycleTrackerCard(),
      ),
    );
  }
}
