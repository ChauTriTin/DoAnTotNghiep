class LocSearch {
  String? district;
  int? count;

  LocSearch({
    this.district,
    this.count,
  });

  LocSearch.fromJson(Map<String, dynamic> json) {
    district = json['district'];
    count = json['count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['district'] = district;
    data['count'] = count;
    return data;
  }
}
