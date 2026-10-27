import 'package:intl/intl.dart';

class DateFormatter {
  DateFormatter._();

  static final DateFormat _dateTimeFormat = DateFormat('dd MMM yyyy, hh:mm a');
  static final DateFormat _dateFormat = DateFormat('dd MMM yyyy');
  static final DateFormat _timeFormat = DateFormat('hh:mm a');

  static String formatDateTime(DateTime? dateTime) {
    if (dateTime == null) return 'N/A';
    return _dateTimeFormat.format(dateTime);
  }

  static String formatDate(DateTime? dateTime) {
    if (dateTime == null) return 'N/A';
    return _dateFormat.format(dateTime);
  }

  static String formatTime(DateTime? dateTime) {
    if (dateTime == null) return 'N/A';
    return _timeFormat.format(dateTime);
  }

  static String formatTimeAgo(DateTime? dateTime) {
    if (dateTime == null) return 'N/A';
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inSeconds < 60) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return formatDate(dateTime);
    }
  }
}
