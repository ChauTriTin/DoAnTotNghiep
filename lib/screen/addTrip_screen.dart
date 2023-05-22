import 'package:doan/gg_maps/google_maps.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:open_street_map_search_and_pick/open_street_map_search_and_pick.dart';

class addTripScreen extends StatefulWidget {
  const addTripScreen({super.key});
  @override
  State<addTripScreen> createState() => _addTripScreenState();
}

class _addTripScreenState extends State<addTripScreen> {
  String textButton1 = 'Hãy chọn điểm xuất phát    ';
  String textButton2 = 'Hãy chọn điểm đến          ';
  String textButton3 = 'Hãy chọn điểm dừng         ';
  LatLng startLocation = LatLng(0, 0);
  LatLng endLocation = LatLng(0, 0);
  LatLng centerLocation = LatLng(0, 0);

  @override
  Widget build(BuildContext context) {
    double _fontSize() {
      double screenWidth = MediaQuery.of(context).size.width;
      if (screenWidth < 380) {
        return 20;
      } else if (screenWidth < 600) {
        return 25;
      } else if (screenWidth < 800) {
        return 27;
      } else {
        return 30;
      }
    }

    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    width: w,
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.orange,
                          width: 2,
                        ),
                      ),
                    ),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 10,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.red[400],
                            borderRadius: BorderRadius.all(
                              Radius.circular(15),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Tạo chuyến đi',
                              style: TextStyle(
                                  fontSize: _fontSize() - 6,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        Spacer(),
                        Text(
                          'Mã: ' + 'ABC123',
                          style: TextStyle(
                            fontSize: _fontSize() - 6,
                            color: Colors.red[700],
                          ),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.copy,
                            color: Colors.red[700],
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10, left: 10, right: 20),
                child: Row(
                  children: [
                    Text(
                      'TIÊU ĐỀ CHUYẾN ĐI CỦA BẠN',
                      style: TextStyle(
                          color: Colors.grey, fontSize: _fontSize() - 6),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.red[300],
                    border: Border.all(width: 2, color: Colors.white),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 5.0),
                    child: TextField(
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10, left: 10, right: 20),
                child: Row(
                  children: [
                    Text(
                      'ĐỊA ĐIỂM XUẤT PHÁT',
                      style: TextStyle(
                          color: Colors.grey, fontSize: _fontSize() - 6),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
                child: OutlinedButton(
                  onPressed: () {
                    bottomMenu(1);
                  },
                  style: OutlinedButton.styleFrom(
                    minimumSize: Size(w * 0.3, w * 0.15),
                    backgroundColor: Colors.red[300],
                    side: BorderSide(color: Colors.white, width: 2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        size: _fontSize() + 5,
                        color: Colors.green[700],
                      ),
                      Text(
                        textButton1.substring(0, 27),
                        style: TextStyle(
                            fontSize: _fontSize() - 7, color: Colors.black),
                      )
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10, left: 10, right: 20),
                child: Row(
                  children: [
                    Text(
                      'ĐỊA ĐIỂM KẾT THÚC',
                      style: TextStyle(
                          color: Colors.grey, fontSize: _fontSize() - 6),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
                child: OutlinedButton(
                  onPressed: () {
                    bottomMenu(2);
                  },
                  style: OutlinedButton.styleFrom(
                    minimumSize: Size(w * 0.3, w * 0.15),
                    backgroundColor: Colors.red[300],
                    side: BorderSide(color: Colors.white, width: 2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        size: _fontSize() + 5,
                        color: Colors.red[700],
                      ),
                      Text(
                        textButton2.substring(0, 27),
                        style: TextStyle(
                            fontSize: _fontSize() - 7, color: Colors.black),
                      )
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10, left: 10, right: 20),
                child: Row(
                  children: [
                    Text(
                      'ĐỊA ĐIỂM DỪNG CHÂN',
                      style: TextStyle(
                          color: Colors.grey, fontSize: _fontSize() - 6),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
                child: OutlinedButton(
                  onPressed: () {
                    bottomMenu(3);
                  },
                  style: OutlinedButton.styleFrom(
                    minimumSize: Size(w * 0.3, w * 0.15),
                    backgroundColor: Colors.red[300],
                    side: BorderSide(color: Colors.white, width: 2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        size: _fontSize() + 5,
                        color: Colors.blue[700],
                      ),
                      Text(
                        textButton3.substring(0, 27),
                        style: TextStyle(
                            fontSize: _fontSize() - 7, color: Colors.black),
                      )
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        minimumSize: Size(w * 0.3, w * 0.1),
                        backgroundColor: Colors.black,
                        side: BorderSide(color: Colors.white, width: 2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Home(
                              startLocation: startLocation,
                              endLocation: endLocation,
                              centerLocation: centerLocation,
                            ),
                          ),
                        );
                      },
                      child: Text(
                        'TẠO',
                        style: TextStyle(
                            fontSize: _fontSize() - 10, color: Colors.red),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  bottomMenu(int IdButton) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext c) {
        return Container(
          width: 800,
          height: 1000,
          decoration: BoxDecoration(
            color: Colors.white,
          ),
          child: OpenStreetMapSearchAndPick(
            center: LatLong(10.771040, 106.701946),
            buttonColor: Colors.blue,
            buttonText: 'Chọn',
            buttonTextColor: Colors.black,
            onPicked: (pickedData) {
              Navigator.pop(context);
              switch (IdButton) {
                case 1:
                  textButton1 = pickedData.address;
                  startLocation = LatLng(pickedData.latLong.latitude,
                      pickedData.latLong.longitude);
                  break;
                case 2:
                  textButton2 = pickedData.address;
                  endLocation = LatLng(pickedData.latLong.latitude,
                      pickedData.latLong.longitude);
                  break;
                case 3:
                  textButton3 = pickedData.address;
                  centerLocation = LatLng(pickedData.latLong.latitude,
                      pickedData.latLong.longitude);
                  break;
                default:
              }
              setState(() {});
            },
            // onPicked: (pickedData) {
            //   print(pickedData.latLong.latitude);
            //   print(pickedData.latLong.longitude);
            //   print(pickedData.address);
            // }
          ),
        );
      },
    );
  }
}
