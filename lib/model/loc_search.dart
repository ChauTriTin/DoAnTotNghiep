class LocSearch {
  String? district;
  String? fullAddress;
  int? count;

  LocSearch({
    this.district,
    this.fullAddress,
    this.count,
  });

  LocSearch.fromJson(Map<String, dynamic> json) {
    district = json['district'];
    fullAddress = json['fullAddress'];
    count = json['count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['district'] = district;
    data['fullAddress'] = fullAddress;
    data['count'] = count;
    return data;
  }
}
