import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

String formatDate(Timestamp inputDate) {
  return DateFormat('yMMMd').format(inputDate.toDate());
}
