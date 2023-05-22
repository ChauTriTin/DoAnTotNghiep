import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Home extends StatefulWidget {
  LatLng startLocation;
  LatLng endLocation;
  LatLng centerLocation;
  Home(
      {required this.startLocation,
      required this.endLocation,
      required this.centerLocation});
  @override
  State<Home> createState() =>
      _HomeState(startLocation, endLocation, centerLocation);
}

class _HomeState extends State<Home> {
  GoogleMapController? mapController; //contrller for Google map
  PolylinePoints polylinePoints = PolylinePoints();

  String googleAPiKey = "AIzaSyCLW1Up21QHcOy8OvNlr-psKaLQep2u3mg";

  Set<Marker> markers = Set(); //markers for google map
  Map<PolylineId, Polyline> polylines = {}; //polylines to show direction

  late LatLng startLocation;
  late LatLng endLocation;
  late LatLng centerLocation;

  _HomeState(LatLng startLocation, LatLng endLocation, LatLng centerLocation) {
    this.startLocation = startLocation;
    this.endLocation = endLocation;
    this.centerLocation = centerLocation;
  }

  @override
  void initState() {
    markers.add(Marker(
      //add start location marker
      markerId: MarkerId(startLocation.toString()),
      position: startLocation, //position of marker
      infoWindow: InfoWindow(
        //popup info
        title: 'Starting Point ',
        snippet: 'Start Marker',
      ),
      icon: BitmapDescriptor.defaultMarkerWithHue(90),
      //Icon for Marker
    ));

    markers.add(Marker(
      //add distination location marker
      markerId: MarkerId(endLocation.toString()),
      position: endLocation, //position of marker
      infoWindow: InfoWindow(
        //popup info
        title: 'Destination Point ',
        snippet: 'Destination Marker',
      ),
      icon: BitmapDescriptor.defaultMarker, //Icon for Marker
    ));
    markers.add(Marker(
      //add distination location marker
      markerId: MarkerId(centerLocation.toString()),
      position: centerLocation, //position of marker
      infoWindow: InfoWindow(
        //popup info
        title: 'Center Point ',
        snippet: 'Center Marker',
      ),
      icon: BitmapDescriptor.defaultMarkerWithHue(200), //Icon for Marker
    ));

    getDirections(); //fetch direction polylines from Google API

    super.initState();
  }

  getDirections() async {
    List<LatLng> polylineCoordinates = [];

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      googleAPiKey,
      PointLatLng(startLocation.latitude, startLocation.longitude),
      PointLatLng(endLocation.latitude, endLocation.longitude),
      // wayPoints: [
      //   PolylineWayPoint(
      //       location: centerLocation.latitude.toString() +
      //           "," +
      //           centerLocation.longitude.toString())
      // ],
      travelMode: TravelMode.driving,
    );

    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    } else {
      print('loi');
    }
    addPolyLine(polylineCoordinates);
  }

  addPolyLine(List<LatLng> polylineCoordinates) {
    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(
      polylineId: id,
      color: Colors.deepPurpleAccent,
      points: polylineCoordinates,
      width: 8,
    );
    polylines[id] = polyline;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Hành trinh di chuyển"),
        backgroundColor: Colors.red[700],
      ),
      body: GoogleMap(
        //Map widget from google_maps_flutter package
        zoomGesturesEnabled: true, //enable Zoom in, out on map
        initialCameraPosition: CameraPosition(
          //innital position in map
          target: startLocation, //initial position
          zoom: 15, //initial zoom level
        ),
        markers: markers, //markers to show on map
        polylines: Set<Polyline>.of(polylines.values), //polylines
        mapType: MapType.normal, //map type
        onMapCreated: (controller) {
          //method called when map is created
          setState(() {
            mapController = controller;
          });
        },
      ),
    );
  }
}
// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:get/get.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';

// class MapSample extends StatefulWidget {
//   const MapSample({Key? key}) : super(key: key);

//   @override
//   State<MapSample> createState() => MapSampleState();
// }

// class MapSampleState extends State<MapSample> {
//   String a = '0';
//   String b = '0';

//   final Completer<GoogleMapController> _controller =
//       Completer<GoogleMapController>();
// //vị trí mặc định
//   static const CameraPosition _kGooglePlex = CameraPosition(
//     target: LatLng(37.42796133580664, -122.085749655962),
//     zoom: 14.4746,
//   );

//   getLocation() async {
//     Position position = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high);
//     double lat = position.latitude;
//     double long = position.longitude;
//   }

//   @override
//   Widget build(BuildContext context) {
//     Future<Position> position =
//         Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
//     return Scaffold(
//       body: GoogleMap(
//         mapType: MapType.normal,
//         initialCameraPosition: _kGooglePlex,
//         onMapCreated: (GoogleMapController controller) {
//           _controller.complete(controller);
//         },
//       ),
//       floatingActionButton: ElevatedButton(
//         onPressed: () {
//           _getLocation().then((value) {
//             a = '${value.latitude}';
//             b = '${value.longitude}';
//           });
//           double lat = double.parse(a);
//           double long = double.parse(b);

//           _goToTheLake(lat, long);
//         },
//         child: Text('Đến vị trí'),
//       ),
//     );
//   }

//   // Future<Position> _goToLoCation() async {
//   //   bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
//   //   if(!serviceEnabled){
//   //     return Future.error('Không thể định vị')
//   //   }
//   // }

//   Future<void> _goToTheLake(double lat, double long) async {
//     final GoogleMapController controller = await _controller.future;
//     controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
//         bearing: 192.8334901395799,
//         target: LatLng(lat, long),

//         // tilt: 59.440717697143555,
//         zoom: 17.151926040649414)));
//   }

//   Future<Position> _getLocation() async {
//     bool seviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!seviceEnabled) {
//       return Future.error('Không lấy được vị trí');
//     }
//     LocationPermission permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) {
//         return Future.error('Không lấy được vị trí.');
//       }
//     }
//     if (permission == LocationPermission.deniedForever) {
//       return Future.error('Loi');
//     }
//     return await Geolocator.getCurrentPosition();
//   }
// }
