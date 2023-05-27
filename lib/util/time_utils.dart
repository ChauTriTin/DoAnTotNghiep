import 'package:date_format/date_format.dart';

class TimeUtils {
  static String convert(DateTime dateTime) {
    return formatDate(dateTime, [dd, '/', mm, '/', yyyy, ' ', HH, ':', nn]);
  }
}
