class LocSearch {
  String? district;
  String? fullAddress;
  int? count;
  List<int>? listRate;

  LocSearch({
    this.district,
    this.fullAddress,
    this.count,
    this.listRate,
  });

  LocSearch.fromJson(Map<String, dynamic> json) {
    district = json['district'];
    fullAddress = json['fullAddress'];
    count = json['count'];
    listRate = json['listRate'].cast<int>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['district'] = district;
    data['fullAddress'] = fullAddress;
    data['count'] = count;
    data['listRate'] = listRate;
    return data;
  }
}
