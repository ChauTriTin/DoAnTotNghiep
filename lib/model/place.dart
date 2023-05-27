class Place {
  static const defaultLat = 10.8231;
  static const defaultLong = 106.6297;

  var lat = defaultLat;
  var long = defaultLong;
  var name = "Chọn địa điểm";

  bool isDefaultPlace() {
    if (lat == defaultLat && long == defaultLong) {
      return true;
    }
    return false;
  }
}
