import 'package:flutter/material.dart';

enum DialogType { error, warning, info }

class EmptyDateDialog extends StatelessWidget {
  final String message;
  final DialogType type;

  const EmptyDateDialog({
    super.key,
    required this.message,
    this.type = DialogType.warning,
  });

  Color get _color {
    switch (type) {
      case DialogType.error:
        return Colors.red.shade600;
      case DialogType.info:
        return Colors.blue.shade600;
      case DialogType.warning:
        return Colors.orange.shade700;
    }
  }

  IconData get _icon {
    switch (type) {
      case DialogType.error:
        return Icons.error_outline;
      case DialogType.info:
        return Icons.info_outline;
      case DialogType.warning:
        return Icons.warning_amber_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: _color.withOpacity(0.15),
                  child: Icon(_icon, color: _color),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    message,
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('OK'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
