import 'package:intl/intl.dart';

/// Created by Loitp on 05,August,2022
/// Galaxy One company,
/// Vietnam
/// +840766040293
/// freuss47@gmail.com
class TimeUtils {
  static const String FORMAT_1 = "dd/MM/yyyy hh:mm:ss";

  static String convertFromMillisecondsSinceEpoch(
      int millisecondsSinceEpoch, String pattern) {
    DateTime date = DateTime.fromMillisecondsSinceEpoch(millisecondsSinceEpoch);
    var format = DateFormat(pattern);
    var dateString = format.format(date);
    return dateString;
  }
}
