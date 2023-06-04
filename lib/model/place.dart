import 'package:appdiphuot/common/const/string_constants.dart';

class Place {
  static const defaultLat = 10.8231;
  static const defaultLong = 106.6297;

  List<String>? imageUrl = [];

  String getFirstImageUrl() {
    return imageUrl?.firstOrNull ?? StringConstants.placeImgDefault;
  }

  double? lat = defaultLat;
  double? long = defaultLong;
  String? name = "Ho Chi Minh";

  bool isDefaultPlace() {
    if (lat == defaultLat && long == defaultLong) {
      return true;
    }
    return false;
  }

  Place({
    this.lat,
    this.long,
    this.name,
  });

  Place.fromJson(Map<String, dynamic> json) {
    lat = json['lat'];
    long = json['long'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['lat'] = lat;
    data['long'] = long;
    data['name'] = name;
    return data;
  }
}
