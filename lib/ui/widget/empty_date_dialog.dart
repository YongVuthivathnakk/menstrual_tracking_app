import 'package:flutter/material.dart';

class EmptyDateDialog extends StatelessWidget {
  const EmptyDateDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(child: Container(child: Text("Wrong Input")));
  }
}
