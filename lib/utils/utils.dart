import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

String formatDate(DateTime dateTime) {
  return DateFormat.yMMMd().format(dateTime);
}

String formatDateFromTimestamp(Timestamp? ts) {
  return DateFormat.yMMMd().add_EEEE().format(ts!.toDate());
}

String formatDateFromTimestampHour(Timestamp? ts) {
  return DateFormat.jm().format(ts!.toDate());
}
