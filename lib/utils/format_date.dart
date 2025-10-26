import 'package:intl/intl.dart';

String formatDate(DateTime date) {
  String formattedDate = '';
  formattedDate = DateFormat('dd/MM/yyyy').format(date);

  return formattedDate;
}