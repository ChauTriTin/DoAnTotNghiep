import 'package:appdiphuot/common/const/string_constants.dart';

class Place {
  static const defaultLat = 10.8231;
  static const defaultLong = 106.6297;

  List<String>? imageUrl = [];

  String getFirstImageUrl() {
    return imageUrl?.firstOrNull ?? StringConstants.placeImgDefault;
  }

  var lat = defaultLat;
  var long = defaultLong;
  var name = "Da Nang";

  bool isDefaultPlace() {
    if (lat == defaultLat && long == defaultLong) {
      return true;
    }
    return false;
  }
}
