class Place {
  var lat = 10.8231;
  var long = 106.6297;
  var name = "Chọn địa điểm";

  bool isDefaultPlace() {
    if (lat == 10.8231 && long == 106.6297) {
      return true;
    }
    return false;
  }
}
