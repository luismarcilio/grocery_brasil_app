import 'package:intl/intl.dart';

String formatDate(DateTime date, {String format = 'dd/MM/yyyy'}) {
  final DateFormat formatter = DateFormat(format);
  return formatter.format(date);
}
