import 'package:date_format/date_format.dart';

class TimeUtils {
  static String convert(DateTime dateTime) {
    if (dateTime == DateTime(1111, 1, 11)) {
      return "Chọn thời gian";
    }
    return formatDate(dateTime, [dd, '/', mm, '/', yyyy, ' ', HH, ':', nn]);
  }
}
