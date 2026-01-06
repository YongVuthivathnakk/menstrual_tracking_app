import 'package:flutter/material.dart';
import 'package:menstrual_tracking_app/ui/widget/cycle_tracker_card.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Image.asset("assets/images/Flow.png")),
      ),
      body: ListView(children: [const CycleTrackerCard()]),
    );
  }
}
