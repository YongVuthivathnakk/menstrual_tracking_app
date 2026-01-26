import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:menstrual_tracking_app/model/period_log.dart';
import 'package:menstrual_tracking_app/model/symptom_log.dart';
import 'package:menstrual_tracking_app/services/menstrual_log_database.dart';
import '../../model/mood_log.dart';
import '../../model/note_log.dart';

class HistoryTab extends StatefulWidget {
  const HistoryTab({super.key});

  @override
  State<HistoryTab> createState() => _HistoryTabState();
}

class _HistoryTabState extends State<HistoryTab> {
  // Raw data from DB
  List<MoodLog> moodLogs = [];
  List<PeriodLog> periodLogs = [];
  List<SymptomLog> symptomLogs = [];
  List<NoteLog> noteLogs = [];

  // Currently selected filter date (null = show all)
  DateTime? _filterDate;

  @override
  void initState() {
    super.initState();
    _getAllData();

    // Listen for global data changes so we refresh automatically when logs are added
  }

  @override
  void dispose() {
    super.dispose();
  }

  // Helpers
  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  Future<void> _confirmDelete({
    required String id,
    required String typeLabel,
    required Future<int> Function(String) deleteFn,
  }) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Log'),
        content: const Text('Are you sure you want to delete this log?'),
        backgroundColor: Colors.white,
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('No', style: TextStyle(color: Colors.black)),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Yes', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      final deleted = await deleteFn(id);
      if (deleted > 0) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                '${typeLabel[0].toUpperCase()}${typeLabel.substring(1)} log deleted',
              ),
            ),
          );
        }
        if (mounted) _getAllData();
      } else {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Nothing was deleted')));
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to delete $typeLabel')));
      }
    }
  }

  // Computed filtered lists (if _filterDate is null, show all)
  List<MoodLog> get _displayMoodLogs {
    if (_filterDate == null) return moodLogs;
    return moodLogs
        .where((log) => _isSameDay(log.logDate, _filterDate!))
        .toList();
  }

  List<SymptomLog> get _displaySymptomLogs {
    if (_filterDate == null) return symptomLogs;
    return symptomLogs
        .where((log) => _isSameDay(log.logDate, _filterDate!))
        .toList();
  }

  List<NoteLog> get _displayNoteLogs {
    if (_filterDate == null) return noteLogs;
    return noteLogs
        .where((log) => _isSameDay(log.logDate, _filterDate!))
        .toList();
  }

  List<PeriodLog> get _displayPeriodLogs {
    if (_filterDate == null) return periodLogs;
    return periodLogs.where((log) {
      // Check if the filter date falls within the period range (inclusive)
      final d = DateTime(
        _filterDate!.year,
        _filterDate!.month,
        _filterDate!.day,
      );
      final start = DateTime(
        log.startDate.year,
        log.startDate.month,
        log.startDate.day,
      );
      final end = DateTime(
        log.endDate.year,
        log.endDate.month,
        log.endDate.day,
      );
      return !d.isBefore(start) && !d.isAfter(end);
    }).toList();
  }

  Future<void> _pickFilterDate() async {
    final today = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _filterDate ?? today,
      firstDate: DateTime(2000),
      lastDate: DateTime(today.year + 5),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: const Color(0xff9A0002), // Blue color for date picker
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _filterDate = DateTime(picked.year, picked.month, picked.day);
      });
    }
  }

  void _clearFilter() {
    setState(() {
      _filterDate = null;
    });
  }

  Widget _buildFilterBar() {
    return Card(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    _filterDate == null
                        ? 'Showing All Logs'
                        : 'Filter: ${DateFormat('d MMM yyyy').format(_filterDate!)}',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),

                FilterButton(onTap: _pickFilterDate),
              ],
            ),
            if (_filterDate != null)
              TextButton(
                onPressed: _clearFilter,
                style: TextButton.styleFrom(
                  side: BorderSide(color: Colors.grey.shade300),
                ),
                child: const Text('Clear', style: TextStyle(color: Colors.red)),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _getAllData() async {
    final newMoodLogs = await MenstrualLogDatabase.instance.getMoodLogs();
    final newSymptomLogs = await MenstrualLogDatabase.instance.getSymptomLogs();
    final newPeriodLogs = await MenstrualLogDatabase.instance.getPeriodLogs();
    final newNoteLogs = await MenstrualLogDatabase.instance.getNoteLogs();

    if (!mounted) return;

    setState(() {
      moodLogs = newMoodLogs;
      symptomLogs = newSymptomLogs;
      periodLogs = newPeriodLogs;
      noteLogs = newNoteLogs;
    });
  }

  String _formatDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _getAllData,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            spacing: 20,
            children: [
              _buildFilterBar(),
              _buildMoodSection(),
              _buildPeriodSection(),
              _buildSymptomSection(),
              _buildNoteSection(),
            ],
          ),
        ),
      ),
    );
  }

  // ------------------ MOOD ------------------

  Widget _buildMoodSection() {
    final items = _displayMoodLogs;
    return SectionCard(
      title: "Mood Logs",
      onTapFilter: _pickFilterDate,
      child: items.isEmpty
          ? const EmptySection(text: "No mood logs yet")
          : Column(
              spacing: 10,
              children: items.map((log) {
                return MoodLogRow(
                  emoji: log.moods.first.emoji,
                  title: log.moods.map((m) => m.label).join(", "),
                  subtitle: "Log Date: ${_formatDate(log.logDate)}",
                  onDelete: () => _confirmDelete(
                    id: log.id,
                    typeLabel: "mood",
                    deleteFn: (id) =>
                        MenstrualLogDatabase.instance.deleteMoodLogById(id),
                  ),
                );
              }).toList(),
            ),
    );
  }

  // ------------------ PERIOD ------------------

  Widget _buildPeriodSection() {
    final items = _displayPeriodLogs;

    return SectionCard(
      title: "Period Logs",
      onTapFilter: _pickFilterDate,
      child: items.isEmpty
          ? const EmptySection(text: "No period logs yet")
          : Column(
              spacing: 10,
              children: items.map((log) {
                return PeriodLogRow(
                  subtitle1: "Log Date: ${_formatDate(log.logDate)}",
                  dateText:
                      "${_formatDate(log.startDate)} - ${_formatDate(log.endDate)}",
                  onDelete: () => _confirmDelete(
                    id: log.id,
                    typeLabel: "period",
                    deleteFn: (id) =>
                        MenstrualLogDatabase.instance.deletePeriodLogById(id),
                  ),
                );
              }).toList(),
            ),
    );
  }

  // ------------------ SYMPTOM ------------------

  Widget _buildSymptomSection() {
    // Flatten symptom entries into a list of widgets (each entry is a row)
    final rows = _displaySymptomLogs.expand((log) {
      return log.symptoms.entries.map((entry) {
        return SymptomLogRow(
          title: entry.key.label,
          subtitle1: "Intensity: ${entry.value.label}",
          subtitle2: "Log Date: ${_formatDate(log.logDate)}",
          onDelete: () => _confirmDelete(
            id: log.id,
            typeLabel: "symptom",
            deleteFn: (id) =>
                MenstrualLogDatabase.instance.deleteSymptomLogById(id),
          ),
        );
      });
    }).toList();

    return SectionCard(
      title: "Symptom Logs",
      onTapFilter: _pickFilterDate,
      child: rows.isEmpty
          ? const EmptySection(text: "No symptom logs yet")
          : Column(spacing: 10, children: rows),
    );
  }

  // ------------------ NOTE ------------------

  Widget _buildNoteSection() {
    final items = _displayNoteLogs;

    return SectionCard(
      title: "Notes",
      onTapFilter: _pickFilterDate,
      child: items.isEmpty
          ? const EmptySection(text: "No notes yet")
          : Column(
              spacing: 10,
              children: [
                ...items.map((log) {
                  return NotesLogRow(
                    heading: log.heading,
                    note: log.note,
                    dateText: "Log Date: ${_formatDate(log.logDate)}",
                    onDelete: () => _confirmDelete(
                      id: log.id,
                      typeLabel: "note",
                      deleteFn: (id) =>
                          MenstrualLogDatabase.instance.deleteNoteLogById(id),
                    ),
                  );
                }),
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

  const SectionCard({
    super.key,
    required this.title,
    required this.child,
    this.onTapFilter,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),

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
              ],
            ),
            const SizedBox(height: 12),

            // content row (one item in your screenshot)
            child,
          ],
        ),
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
    return OutlinedButton.icon(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: Colors.grey.shade300),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      icon: const Icon(Icons.calendar_today, size: 16, color: Colors.black),
      label: const Text(
        "Filter",
        style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
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
  final VoidCallback? onDelete;

  const MoodLogRow({
    super.key,
    required this.emoji,
    required this.title,
    required this.subtitle,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return _ItemBox(
      left: _EmojiCircle(emoji: emoji),
      title: title,
      subtitleLines: [subtitle],
      right: IconButton(
        onPressed: onDelete,
        icon: const Icon(Icons.delete, size: 20, color: Colors.red),
      ),
    );
  }
}

/// -------------------------
/// Period row (date + edit/delete icons)
/// -------------------------
class PeriodLogRow extends StatelessWidget {
  final String dateText;
  final VoidCallback? onDelete;
  final String subtitle1;

  const PeriodLogRow({
    super.key,
    required this.dateText,
    this.onDelete,
    required this.subtitle1,
  });

  @override
  Widget build(BuildContext context) {
    return _ItemBox(
      left: const SizedBox(width: 0, height: 0), // no emoji in screenshot
      title: dateText,
      subtitleLines: [subtitle1],
      right: IconButton(
        onPressed: onDelete,
        icon: const Icon(Icons.delete, size: 20, color: Colors.red),
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
  final VoidCallback? onDelete;

  const SymptomLogRow({
    super.key,
    required this.title,
    required this.subtitle1,
    required this.subtitle2,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return _ItemBox(
      left: const SizedBox(width: 0, height: 0),
      title: title,
      subtitleLines: [subtitle1, subtitle2],
      leftWidth: 0,
      right: IconButton(
        onPressed: onDelete,
        icon: const Icon(Icons.delete, size: 20, color: Colors.red),
      ),
    );
  }
}

/// -------------------------
/// Shared item container style (the gray inner box)
/// -------------------------
class _ItemBox extends StatelessWidget {
  final Widget left;
  final Widget? right;
  final String title;
  final List<String> subtitleLines;
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
            SizedBox(
              width: leftWidth,
              height: 44,
              child: Center(child: left),
            ),
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

/// -------------------------
/// Note row (note text + date)
/// -------------------------
class NotesLogRow extends StatelessWidget {
  final String note;
  final String heading;
  final String dateText;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const NotesLogRow({
    super.key,
    required this.note,
    required this.dateText,
    this.onEdit,
    this.onDelete,
    required this.heading,
  });

  @override
  Widget build(BuildContext context) {
    return _ItemBox(
      left: const SizedBox(width: 0, height: 0),
      title: heading,
      subtitleLines: [dateText, note],
      right: IconButton(
        onPressed: onDelete,
        icon: const Icon(Icons.delete, size: 20, color: Colors.red),
      ),
      leftWidth: 0,
    );
  }
}

class EmptySection extends StatelessWidget {
  final String text;
  const EmptySection({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(text, style: const TextStyle(color: Colors.grey));
  }
}
