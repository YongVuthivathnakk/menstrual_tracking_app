import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:menstrual_tracking_app/ui/pages/history_page.dart';
import 'package:menstrual_tracking_app/ui/widget/cycle_tracker_card.dart';
import 'package:menstrual_tracking_app/utils/svg_icons.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  //final String pageId;

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
        title: Center(child: Image.asset("assets/images/Flow.png")),
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
        onTap: (index){
          setState((){
            _currentTab = PageTab.values[index];
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: SvgPicture.asset(SvgIcons.house, width: 24, height: 24),
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(SvgIcons.history, width: 24, height: 24),
          ),
        ],
      ),
      //CycleTrackerCard(),
      // bottomNavigationBar: BottomNavigationBar(
      //   items: 
      // ),
    );
  }
}


// class Homepage extends StatelessWidget {
//   const Homepage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Center(child: Image.asset("assets/images/Flow.png")),
//       ),
//       body: CycleTrackerCard(),
//       bottomNavigationBar: BottomNavigationBar(
//         selectedItemColor: Colors.white,
//       ),
//     );
//   }
// }
