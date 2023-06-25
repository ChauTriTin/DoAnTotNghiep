import 'package:google_maps_directions/google_maps_directions.dart';

import '../model/place.dart';
import '../model/trip.dart';
import 'log_dog_utils.dart';

class DistanceUtil {
  static Future<double> getTotalKm(List<Trip> trips) async {
    // try {
    double totalKmTemp = 0;
    for (var trip in trips) {
      if (trip.listPlace == null || trip.listPlace?.isEmpty == true) {
        double km = await _genDistance(trip.placeStart, trip.placeEnd);
        totalKmTemp = totalKmTemp + km;
        Dog.d("getTotalKm km of ${trip.title}: $km");
      } else {
        Place? startPlace = trip.placeStart;
        trip.listPlace?.forEach((place) async {
          double km = await _genDistance(startPlace, place);
          totalKmTemp = totalKmTemp + km;

          startPlace = place;
        });

        double km = await _genDistance(startPlace, trip.placeEnd);
        totalKmTemp = totalKmTemp + km;
      }
    }
    Dog.d("getTotalKm km: $totalKmTemp");
    return totalKmTemp;
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
