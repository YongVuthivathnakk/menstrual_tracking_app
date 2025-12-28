import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:menstrual_tracking_app/ui/widget/back_app_bar.dart';
import 'package:menstrual_tracking_app/ui/widget/calandar_card.dart';
import 'package:menstrual_tracking_app/utils/svg_icons.dart';

class CalandarPage extends StatefulWidget {
  const CalandarPage({super.key});

  @override
  State<CalandarPage> createState() => _CalandarPageState();
}

class _CalandarPageState extends State<CalandarPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: BackAppBar(), body: DefaultCalandar());
  }
}
