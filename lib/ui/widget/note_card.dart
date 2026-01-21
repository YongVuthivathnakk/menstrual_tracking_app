import 'package:flutter/material.dart';
import 'package:menstrual_tracking_app/utils/log_header.dart';

class NoteCard extends StatefulWidget {
  final TextEditingController headingController;
  final TextEditingController noteController;

  const NoteCard({
    super.key,

    required this.headingController,
    required this.noteController,
  });

  @override
  State<NoteCard> createState() => _NoteCardState();
}

class _NoteCardState extends State<NoteCard> {
  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Card(
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
              ),
              ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 300),
                child: NoteInputField(
                  hint: "Tell us about your day...",
                  maxLines: 20,
                  minLines: 5,
                  textController: widget.noteController,
                ),
              ),
            ],
          ),
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

  const NoteInputField({
    super.key,
    required this.textController,
    required this.hint,
    this.minLines = 1,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: textController,

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
