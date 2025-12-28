import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:menstrual_tracking_app/utils/svg_icons.dart';

class BackAppBar extends StatelessWidget implements PreferredSizeWidget {
  const BackAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    void onBack() {
      Navigator.pop(context);
    }

    return AppBar(
      leading: IconButton(
        onPressed: onBack,
        icon: SvgPicture.asset(SvgIcons.arrowLeft, width: 20, height: 20),
      ),
      title: Text("Back to Dashboard", style: TextStyle(fontSize: 14)),
      titleSpacing: 0,
    );
  }
}
