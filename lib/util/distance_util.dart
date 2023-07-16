import 'package:google_maps_directions/google_maps_directions.dart';

import '../model/place.dart';
import '../model/trip.dart';
import 'log_dog_utils.dart';

class DistanceUtil {
  static Future<double> getTotalKm(List<Trip> trips) async {
    // try {
    double totalKm = 0;
    Dog.d("getTotalKm trips: ${trips.length}");

    for (var trip in trips) {
      var listPlace = <Place>[];
      listPlace.add(trip.placeStart!);
      listPlace.addAll(trip.listPlace ?? []);
      listPlace.add(trip.placeEnd!);

      double kmTemp = 0;
      for (int i = 0; i < listPlace.length - 1; i++) {
        double km = await _genDistance(listPlace[i], listPlace[i + 1]);
        kmTemp += km;
        Dog.d(
            "getTotalKm ${trip.title} Km of ${listPlace[i].fullAddress} -> ${listPlace[i + 1].fullAddress}: $km");
      }
      totalKm += kmTemp;
      Dog.d("getTotalKm: totalKm: $totalKm -- km of ${trip.title}: $kmTemp");
    }
    Dog.d("getTotalKm km: $totalKm");
    return double.parse(totalKm.toStringAsFixed(2));
    // }catch (e){
    //   Dog.e("getTotalKm exeption: $e");
    // }
  }

  static Future<double> _genDistance(Place? placeA, Place? placeB) async {
    Dog.d(
        "_genDistance: - A: ${placeA?.lat} - ${placeA?.long},  B: ${placeB?.lat} - ${placeB?.long}");
    if (placeA == null || placeB == null) return 0;
    DistanceValue distanceBetween = await distance(
      placeA.lat ?? 0,
      placeA.long ?? 0,
      placeB.lat ?? 0,
      placeB.long ?? 0,
    );
    int meters = distanceBetween.meters;
    String textInKmOrMeters = distanceBetween.text;
    Dog.d(">>>_genDistance meters $meters, textInKmOrMeters $textInKmOrMeters");
    return meters / 1000;
  }
}
