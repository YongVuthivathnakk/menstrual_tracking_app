import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
//import 'package:flutter_svg/flutter_svg.dart';
import 'package:menstrual_tracking_app/ui/pages/history_page.dart';
import 'package:menstrual_tracking_app/ui/widget/cycle_tracker_card.dart';
import 'package:menstrual_tracking_app/utils/svg_icons.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

enum PageTab { homeTab, historyTab }

class _HomePageState extends State<HomePage> {
  PageTab _currentTab = PageTab.homeTab;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: _currentTab == PageTab.homeTab
              ? Image.asset("assets/images/Flow.png")
              : Image.asset("assets/images/History.png"),
        ),
      ),
      body: IndexedStack(
        index: _currentTab.index,
        children: [
          CycleTrackerCard(),
          HistoryPage(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentTab.index,
        selectedItemColor: Colors.white,
        backgroundColor: const Color(0xff9A0002),
        onTap: (index){
          setState((){
            _currentTab = PageTab.values[index];
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: SvgPicture.asset(SvgIcons.house, width: 24, height: 24, colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn)),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(SvgIcons.history, width: 24, height: 24, colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn)),
            label: 'History',
          ),
        ],
      ),
    );
  }
}