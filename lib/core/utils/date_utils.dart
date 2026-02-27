import 'package:intl/intl.dart';

String dayKey(DateTime date) => DateFormat('yyyy-MM-dd').format(date);

List<String> lastNDaysKeys(int n) {
  final now = DateTime.now();
  return List.generate(n, (i) => dayKey(now.subtract(Duration(days: n - i - 1))));
}
