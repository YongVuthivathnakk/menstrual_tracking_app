import 'package:flutter/material.dart';
import 'package:menstrual_tracking_app/utils/log_header.dart';

class NoteCard extends StatefulWidget {
  final String note;
  final String heading;
  final TextEditingController headingController;
  final TextEditingController noteController;
  final ValueChanged<String> onHeadingChanged;
  final ValueChanged<String> onNoteChanged;

  const NoteCard({
    super.key,
    required this.note,
    required this.heading,
    required this.onHeadingChanged,
    required this.onNoteChanged,
    required this.headingController,
    required this.noteController,
  });

  @override
  State<NoteCard> createState() => _NoteCardState();
}

class _NoteCardState extends State<NoteCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 20,
          children: [
            LogHeader(
              title: "Note",
              description: "Add any additional note (Optional):",
            ),

            NoteInputField(
              hint: "Heading",
              textController: widget.headingController,
              onChanged: widget.onHeadingChanged,
            ),
            NoteInputField(
              hint: "Tell us about your day...",
              maxLines: 20,
              minLines: 5,
              textController: widget.noteController,
              onChanged: widget.onNoteChanged,
            ),
          ],
        ),
      ),
    );
  }
}

class NoteInputField extends StatelessWidget {
  final String hint;
  final int minLines;
  final int maxLines;
  final TextEditingController textController;
  final ValueChanged<String>? onChanged;

  const NoteInputField({
    super.key,
    required this.textController,
    required this.hint,
    this.minLines = 1,
    this.maxLines = 1,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: textController,
      onChanged: onChanged,
      keyboardType: TextInputType.multiline,
      textInputAction: TextInputAction.newline,
      minLines: minLines,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 15),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 12,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.grey.shade300, width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.blue, width: 1.5),
        ),
      ),
    );
  }
}
