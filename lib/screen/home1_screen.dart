import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'addTrip_screen.dart';

class home1Screen extends StatefulWidget {
  const home1Screen({super.key});

  @override
  State<home1Screen> createState() => _home1Screen();
}

class _home1Screen extends State<home1Screen> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
    Text(
      'Index 0: Home',
      style: optionStyle,
    ),
    addTripScreen(),
    Text(
      'Index 1: Business',
      style: optionStyle,
    ),
    Text(
      'Index 2: School',
      style: optionStyle,
    ),
    Text(
      'Index 3: Settings',
      style: optionStyle,
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Tên người dùng'),
        backgroundColor: Colors.red[700],
        actions: [
          Padding(
            padding: const EdgeInsets.only(top: 5, bottom: 5, right: 20),
            child: Material(
              shape: CircleBorder(),
              clipBehavior: Clip.antiAliasWithSaveLayer,
              child: InkWell(
                child: Ink.image(
                  image: NetworkImage(
                      "https://staticg.sportskeeda.com/editor/2022/09/71751-16644793436395-1920.jpg"),
                  height: 50,
                  width: 50,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Trang chủ',
            backgroundColor: Color.fromRGBO(211, 47, 47, 1),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.add_circle_outline,
              size: 25,
            ),
            label: 'Tạo chuyến đi',
            backgroundColor: Color.fromRGBO(211, 47, 47, 1),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Trang cá nhân',
            backgroundColor: Color.fromRGBO(211, 47, 47, 1),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_none),
            label: 'Thông báo',
            backgroundColor: Color.fromRGBO(211, 47, 47, 1),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_rounded),
            label: 'Khác',
            backgroundColor: Color.fromRGBO(211, 47, 47, 1),
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.white,
        onTap: _onItemTapped,
      ),
    );
  }
}
