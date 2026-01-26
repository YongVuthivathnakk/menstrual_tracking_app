import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
//import 'package:flutter_svg/flutter_svg.dart';
import 'package:menstrual_tracking_app/ui/tabs/history_tab.dart';
import 'package:menstrual_tracking_app/ui/tabs/home_tab.dart';
import 'package:menstrual_tracking_app/utils/svg_icons.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

enum PageTab { homeTab, historyTab }

class _HomePageState extends State<HomePage> {
  PageTab _currentTab = PageTab.homeTab;

  // Lazily create tab widgets and keep them alive so switching doesn't reinit
  final List<Widget?> _pages = [const HomeTab(), null];

  @override
  Widget build(BuildContext context) {
    // return TestPage();
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Center(
          child: _currentTab == PageTab.homeTab
              ? Image.asset("assets/images/Flow.png")
              : Image.asset("assets/images/History.png"),
        ),
      ),
      body: IndexedStack(
        index: _currentTab.index,
        children: _pages.map((w) => w ?? const SizedBox()).toList(),
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentTab.index,
        selectedItemColor: Colors.white,
        unselectedItemColor: const Color(0xffE39895),
        backgroundColor: const Color(0xff9A0002),
        onTap: (index) {
          setState(() {
            _currentTab = PageTab.values[index];
            if (_pages[index] == null) {
              _pages[index] = index == 0 ? const HomeTab() : const HistoryTab();
            }
          });

          // Refresh handled via DataChangeNotifier subscription in HistoryTab
        },
        items: [
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              SvgIcons.house,
              width: 24,
              height: 24,
              colorFilter: ColorFilter.mode(
                _currentTab == PageTab.homeTab
                    ? Colors.white
                    : const Color(0xffE39895),
                BlendMode.srcIn,
              ),
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              SvgIcons.history,
              width: 24,
              height: 24,
              colorFilter: ColorFilter.mode(
                _currentTab == PageTab.historyTab
                    ? Colors.white
                    : const Color(0xffE39895),
                BlendMode.srcIn,
              ),
            ),
            label: 'History',
          ),
        ],
      ),
    );
  }
}
