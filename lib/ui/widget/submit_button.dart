import 'package:flutter/material.dart';

class SubmitButton extends StatelessWidget {
  final String label;
  final VoidCallback onSubmit;

  const SubmitButton({super.key, required this.label, required this.onSubmit});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: TextButton(
        onPressed: onSubmit,
        style: TextButton.styleFrom(
          backgroundColor: Color(0xffE39895),
          fixedSize: Size(350, 40),
        ),
        child: Text(
          label,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
