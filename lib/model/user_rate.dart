class UserRate {
  String? idUser;
  String? tripID;
  double? rate;

  UserRate(this.idUser, this.tripID, this.rate);

  @override
  String toString() {
    return 'UserRate{idUser: $idUser, tripID: $tripID, rate: $rate}';
  }

  UserRate.fromJson(Map<String, dynamic> json) {
    idUser = json['idUser'];
    tripID = json['tripID'];
    rate = json['rate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['idUser'] = idUser;
    data['tripID'] = tripID;
    data['rate'] = rate;
    return data;
  }
}
