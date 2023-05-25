import 'package:appdiphuot/ui/home/chat/page_chat_screen.dart';
import 'package:appdiphuot/ui/home/home/page_home_screen.dart';
import 'package:appdiphuot/ui/home/noti/page_noti_screen.dart';
import 'package:appdiphuot/ui/home/user/page_user_screen.dart';
import 'package:circular_bottom_navigation/circular_bottom_navigation.dart';
import 'package:circular_bottom_navigation/tab_item.dart';
import 'package:flutter/material.dart';

import '../../base/base_stateful_state.dart';
import '../../common/const/color_constants.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends BaseStatefulState<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.appColorBkg,
      body: const Directionality(
        // use this property to change direction in whole app
        // CircularBottomNavigation will act accordingly
        textDirection: TextDirection.ltr,
        child: HomePage(),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({
    Key? key,
  }) : super(key: key);

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  int selectedPos = 0;

  double bottomNavBarHeight = 60;

  List<TabItem> tabItems = List.of([
    TabItem(
      Icons.home,
      "Home",
      Colors.blue,
      labelStyle: const TextStyle(
        fontWeight: FontWeight.normal,
      ),
    ),
    TabItem(
      Icons.mark_chat_unread,
      "Chat",
      Colors.orange,
      labelStyle: const TextStyle(
        color: Colors.red,
        fontWeight: FontWeight.bold,
      ),
    ),
    TabItem(
      Icons.notification_add,
      "Notification",
      Colors.red,
      circleStrokeColor: Colors.black,
    ),
    TabItem(
      Icons.people,
      "Profile",
      Colors.cyan,
    ),
  ]);

  late CircularBottomNavigationController _navigationController;

  @override
  void initState() {
    super.initState();
    _navigationController = CircularBottomNavigationController(selectedPos);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: bottomNavBarHeight),
            child: bodyContainer(),
          ),
          Align(alignment: Alignment.bottomCenter, child: bottomNav())
        ],
      ),
    );
  }

  Widget bodyContainer() {
    Color? selectedColor = tabItems[selectedPos].circleColor;

    Widget buildPage() {
      switch (selectedPos) {
        case 0:
          return const PageHomeScreen();
        case 1:
          return const PageChatScreen();
        case 2:
          return const PageNotiScreen();
        case 3:
          return const PageUserScreen();
        default:
          return const PageHomeScreen();
      }
    }

    return GestureDetector(
      child: Container(
        width: double.infinity,
        height: double.infinity,
        color: selectedColor,
        child: buildPage(),
      ),
      onTap: () {
        if (_navigationController.value == tabItems.length - 1) {
          _navigationController.value = 0;
        } else {
          _navigationController.value = _navigationController.value! + 1;
        }
      },
    );
  }

  Widget bottomNav() {
    return CircularBottomNavigation(
      tabItems,
      controller: _navigationController,
      selectedPos: selectedPos,
      barHeight: bottomNavBarHeight,
      barBackgroundColor: Colors.white,
      backgroundBoxShadow: const <BoxShadow>[
        BoxShadow(color: Colors.black45, blurRadius: 10.0),
      ],
      animationDuration: const Duration(milliseconds: 300),
      selectedCallback: (int? selectedPos) {
        setState(() {
          this.selectedPos = selectedPos ?? 0;
        });
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    _navigationController.dispose();
  }
}
