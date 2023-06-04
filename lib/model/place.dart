import 'dart:math';

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

  static Place getRandomPlace() {
    var list = <Place>[];
    list.add(
      Place(
        lat: 10.762622,
        long: 106.660172,
        name: "Ho Chi Minh City, Vietnam",
      ),
    );
    list.add(
      Place(
        lat: 20.865139,
        long: 106.683830,
        name: "Haiphong, Vietnam",
      ),
    );
    list.add(
      Place(
        lat: 9.602521,
        long: 105.97390,
        name: "Sóc Trăng, Soc Trang, Vietnam",
      ),
    );
    list.add(
      Place(
        lat: 16.463713,
        long: 107.590866,
        name: "Huế, Thua Thien Hue, Vietnam",
      ),
    );
    list.add(
      Place(
        lat: 10.924067,
        long: 106.713028,
        name: "Thuận An, Binh Duong, Vietnam",
      ),
    );
    list.add(
      Place(
        lat: 21.028511,
        long: 105.804817,
        name: "Hanoi, Vietnam",
      ),
    );
    list.add(
      Place(
        lat: 10.964112,
        long: 106.856461,
        name: "Biên Hòa, Dong Nai, Vietnam",
      ),
    );

    var ran = Random().nextInt(list.length - 1);
    return list[ran];
  }
}
