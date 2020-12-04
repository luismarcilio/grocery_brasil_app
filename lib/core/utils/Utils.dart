import 'package:cloud_firestore/cloud_firestore.dart';

String enumToString(Object o) => o.toString().split('.').last;

T enumFromString<T>(String key, List<T> values) =>
    values.firstWhere((v) => key == enumToString(v), orElse: () => null);

DateTime dateTimeFromJsonOrTimestamp(dynamic input) {
  if (input == null) {
    return null;
  }
  if (input is String) {
    return DateTime.parse(input);
  }
  if (input is Timestamp) {
    return DateTime.fromMillisecondsSinceEpoch(input.millisecondsSinceEpoch);
  }
  throw Exception(
      '$input: ${input.runtimeType.toString()} cannot be converted to DateTime');
}
