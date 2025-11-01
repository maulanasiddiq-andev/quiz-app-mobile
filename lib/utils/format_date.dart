import 'package:intl/intl.dart';

String formatDate(DateTime? date) {
  if (date == null) {
    return "-";
  }
  
  String formattedDate = '';
  formattedDate = DateFormat('dd/MM/yyyy').format(date);

  return formattedDate;
}