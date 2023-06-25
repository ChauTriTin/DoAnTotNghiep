class Rate {
  double? rateLeader;
  double? rateTrip;
  double? ratePlaceStart;
  double? ratePlaceEnd;
  List<double>? rateListPlaceStop;

  Rate({
    this.rateLeader,
    this.rateTrip,
    this.ratePlaceStart,
    this.ratePlaceEnd,
    this.rateListPlaceStop,
  });

  Rate.fromJson(Map<String, dynamic> json) {
    rateLeader = json['rateLeader'];
    rateTrip = json['rateTrip'];
    ratePlaceStart = json['ratePlaceStart'];
    ratePlaceEnd = json['ratePlaceEnd'];
    rateListPlaceStop = json['rateListPlaceStop'].cast<double>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['rateLeader'] = rateLeader;
    data['rateTrip'] = rateTrip;
    data['ratePlaceStart'] = ratePlaceStart;
    data['ratePlaceEnd'] = ratePlaceEnd;
    data['rateListPlaceStop'] = rateListPlaceStop;
    return data;
  }
}
