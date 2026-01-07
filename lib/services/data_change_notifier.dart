import 'package:flutter/foundation.dart';

/// Simple global notifier to broadcast when any log data changes.
/// HistoryTab subscribes to [version] and refreshes when it increments.
class DataChangeNotifier {
  DataChangeNotifier._();

  static final DataChangeNotifier instance = DataChangeNotifier._();

  final ValueNotifier<int> version = ValueNotifier<int>(0);

  void notify() {
    version.value++;
  }
}
