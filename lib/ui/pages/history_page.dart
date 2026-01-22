import 'package:flutter/material.dart';
import '../../model/mood_log.dart';
//import '../../model/note_log.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final moodLog = (id: "1", moods: [Mood.happy]);
    final moodDate = DateTime(2025, 12, 18);
    final periodDate = DateTime(2025, 11, 2);
    final symptomTitle = "Back Pain";
    final symptomIntensity = "Intensity: Moderate";
    final symptomDate = DateTime(2025, 12, 18);
    final noteDate = DateTime(2025, 12, 20);
    final noteLog = (
      id: "1",
      logDate: _formatDate(noteDate),
      note: "Need to buy a heating pad.",
    );

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
      child: Column(
        children: [
          SectionCard(
            title: "Mood Logs",
            onTapFilter: () => debugPrint("Mood filter tapped"),
            child: MoodLogRow(
              emoji: moodLog.moods.first.emoji,
              title: moodLog.moods.first.label,
              subtitle: _formatDate(moodDate),
            ),
          ),
          const SizedBox(height: 16),

          SectionCard(
            title: "Period Logs",
            onTapFilter: () => debugPrint("Period filter tapped"),
            child: PeriodLogRow(
              dateText: _formatDate(periodDate),
              onEdit: () => debugPrint("Edit period log"),
              onDelete: () => debugPrint("Delete period log"),
            ),
          ),
          const SizedBox(height: 16),

          SectionCard(
            title: "Symptom Logs",
            onTapFilter: () => debugPrint("Symptom filter tapped"),
            child: SymptomLogRow(
              title: symptomTitle,
              subtitle1: symptomIntensity,
              subtitle2: _formatDate(symptomDate),
            ),
          ),

          const SizedBox(height: 16),

          SectionCard(
            title: "Note Logs",
            onTapFilter: () => debugPrint("Note filter tapped"),
            child: NotesLogRow(
              note: noteLog.note,
              dateText: noteLog.logDate,
              onEdit: () => debugPrint("Edit note log"),
              onDelete: () => debugPrint("Delete note log"),
            ),
          ),
        ],
      ),
    );
  }
}

/// -------------------------
/// Reusable Section Card (Mood/Period/Symptom)
/// -------------------------
class SectionCard extends StatelessWidget {
  final String title;
  final VoidCallback? onTapFilter;
  final Widget child;
  final String? description;

  const SectionCard({
    super.key,
    required this.title,
    required this.child,
    this.description,
    this.onTapFilter,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          // header row: title + filter button
          Row(
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 16,
                ),
              ),
              const Spacer(),
              FilterButton(onTap: onTapFilter),
            ],
          ),
          if (description != null) ...[
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                description!,
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 13,
                  height: 1.3,
                ),
              ),
            ),
          ],
          const SizedBox(height: 12),

          // content row (one item in your screenshot)
          child,
        ],
      ),
    );
  }
}

/// -------------------------
/// Filter Button UI
/// -------------------------
class FilterButton extends StatelessWidget {
  final VoidCallback? onTap;

  const FilterButton({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Row(
          children: [
            Icon(Icons.calendar_today, size: 16),
            SizedBox(width: 8),
            Text("Filter", style: TextStyle(fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}

/// -------------------------
/// Mood row (emoji circle + title + date)
/// -------------------------
class MoodLogRow extends StatelessWidget {
  final String emoji;
  final String title;
  final String subtitle;

  const MoodLogRow({
    super.key,
    required this.emoji,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return _ItemBox(
      left: _EmojiCircle(emoji: emoji),
      title: title,
      subtitleLines: [subtitle],
    );
  }
}

/// -------------------------
/// Period row (date + edit/delete icons)
/// -------------------------
class PeriodLogRow extends StatelessWidget {
  final String dateText;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const PeriodLogRow({
    super.key,
    required this.dateText,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return _ItemBox(
      left: const SizedBox(width: 0, height: 0), // no emoji in screenshot
      title: dateText,
      subtitleLines: const [],
      right: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: onEdit,
            icon: const Icon(Icons.edit, size: 20),
          ),
          IconButton(
            onPressed: onDelete,
            icon: const Icon(Icons.delete, size: 20, color: Colors.red),
          ),
        ],
      ),
      leftWidth: 0,
    );
  }
}

/// -------------------------
/// Symptom row (title + intensity + date)
/// -------------------------
class SymptomLogRow extends StatelessWidget {
  final String title;
  final String subtitle1;
  final String subtitle2;

  const SymptomLogRow({
    super.key,
    required this.title,
    required this.subtitle1,
    required this.subtitle2,
  });

  @override
  Widget build(BuildContext context) {
    return _ItemBox(
      left: const SizedBox(width: 0, height: 0),
      title: title,
      subtitleLines: [subtitle1, subtitle2],
      leftWidth: 0,
    );
  }
}

/// -------------------------
/// Shared item container style (the gray inner box)
/// -------------------------
class _ItemBox extends StatelessWidget {
  final Widget left;
  final String title;
  final List<String> subtitleLines;
  final Widget? right;
  final double leftWidth;

  const _ItemBox({
    required this.left,
    required this.title,
    required this.subtitleLines,
    this.right,
    this.leftWidth = 44,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF6F6F6),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (leftWidth > 0) ...[
            SizedBox(width: leftWidth, height: 44, child: Center(child: left)),
            const SizedBox(width: 12),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 13,
                  ),
                ),
                if (subtitleLines.isNotEmpty) const SizedBox(height: 4),
                for (final line in subtitleLines)
                  Text(
                    line,
                    style: const TextStyle(
                      fontSize: 11,
                      color: Colors.black54,
                      height: 1.2,
                    ),
                  ),
              ],
            ),
          ),
          if (right != null) right!,
        ],
      ),
    );
  }
}

/// -------------------------
/// Emoji circle (Mood row)
/// -------------------------
class _EmojiCircle extends StatelessWidget {
  final String emoji;
  const _EmojiCircle({required this.emoji});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: const Color(0xFFFFF3C7),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Text(emoji, style: const TextStyle(fontSize: 22)),
    );
  }
}

/// Simple date formatting (no packages)
String _formatDate(DateTime d) {
  const months = ["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"];
  return "${months[d.month - 1]} ${d.day}, ${d.year}";
}

/// -------------------------
/// Note row (note text + date)
/// -------------------------
class NotesLogRow extends StatelessWidget {
  final String note;
  final String dateText;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const NotesLogRow({
    super.key,
    required this.note,
    required this.dateText,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return _ItemBox(
      left: const SizedBox(width: 0, height: 0),
      title: note,
      subtitleLines: [dateText],
      right: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: onEdit,
            icon: const Icon(Icons.edit, size: 20),
          ),
          IconButton(
            onPressed: onDelete,
            icon: const Icon(Icons.delete, size: 20, color: Colors.red),
          ),
        ],
      ),
      leftWidth: 0,
    );
  }
}
