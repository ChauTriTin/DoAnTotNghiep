import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

class TimeUtils {
  static String convert(DateTime dateTime) {
    if (dateTime == DateTime(1111, 1, 11)) {
      return "Chọn thời gian";
    }
    return formatDate(dateTime, [dd, '/', mm, '/', yyyy, ' ', HH, ':', nn]);
  }

  static DateTime? stringToDateTime(String? dateTimeString) {
    if (dateTimeString == null || dateTimeString.isEmpty) {
      return null;
    }

    try {
      DateFormat format = DateFormat('dd/MM/yyyy HH:mm');
      debugPrint("editRouter dateTimeString $dateTimeString");
      DateTime dateTime = format.parse(dateTimeString);
      return dateTime;
    } catch (e) {
      debugPrint("editRouter $e");
      return null;
    }
  }

  static String dateTimeToString(DateTime? dateTime) {
    try {
      if (dateTime == null || dateTime == DateTime(1111, 1, 11)) {
        return "";
      }
      return formatDate(dateTime, [dd, '/', mm, '/', yyyy]);
    } catch (e) {
      return "";
    }
  }


  static String dateTimeToString1(DateTime? dateTime) {
    try {
      if (dateTime == null || dateTime == DateTime(1111, 1, 11)) {
        return "";
      }
      return formatDate(dateTime, [dd, '/', mm, '/', yyyy, " ", hh, ":", mm]);
    } catch (e) {
      return "";
    }
  }


  static String formatDateTimeFromMilliseconds(int milliseconds) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(milliseconds);
    DateFormat dateFormat = DateFormat('HH:mm dd/MM/yyyy');
    return dateFormat.format(dateTime);
  }
}
