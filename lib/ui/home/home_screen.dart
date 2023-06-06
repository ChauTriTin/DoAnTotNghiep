import 'package:appdiphuot/common/const/dimen_constants.dart';
import 'package:appdiphuot/model/push_notification.dart';
import 'package:appdiphuot/ui/home/chat/page_chat_screen.dart';
import 'package:appdiphuot/ui/home/home/page_home_screen.dart';
import 'package:appdiphuot/ui/home/home_controller.dart';
import 'package:appdiphuot/ui/home/noti/page_noti_screen.dart';
import 'package:appdiphuot/ui/home/user/page_user_screen.dart';
import 'package:circular_bottom_navigation/circular_bottom_navigation.dart';
import 'package:circular_bottom_navigation/tab_item.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:overlay_support/overlay_support.dart';

import '../../base/base_stateful_state.dart';
import '../../common/const/color_constants.dart';
import '../../view/profile_bar_widget.dart';

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
  PushNotification? _notificationInfo;
  late final FirebaseMessaging _messaging;

  int selectedPos = 0;
  final _controller = Get.put(HomeController());
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
    registerNotification();

    _navigationController = CircularBottomNavigationController(selectedPos);
    _setupListen();
    _controller.getUserInfo();

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint('FCM listen onMessageOpenedApp ${message.data}');
      PushNotification notification = PushNotification(
        title: message.notification?.title,
        body: message.notification?.body,
        dataTitle: message.data['title'],
        dataBody: message.data['body'],
      );
      setState(() {
        _notificationInfo = notification;
      });
    });

    checkForInitialMessage();
  }

  checkForInitialMessage() async {
    await Firebase.initializeApp();
    RemoteMessage? message =
        await FirebaseMessaging.instance.getInitialMessage();
    if (message != null) {
      PushNotification notification = PushNotification(
        title: message.notification?.title,
        body: message.notification?.body,
        dataTitle: message.data['title'],
        dataBody: message.data['body'],
      );

      setState(() {
        _notificationInfo = notification;
        debugPrint(
            "FCM checkForInitialMessage notification ${notification.toString()}");
      });
    }
  }

  Future _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    debugPrint("FCM Handling a background message: ${message.messageId}");
  }

  void registerNotification() async {
    await Firebase.initializeApp();
    _messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      provisional: false,
      sound: true,
    );

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      debugPrint('FCM User granted permission');
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        debugPrint('FCM listen RemoteMessage ${message.data}');
        debugPrint('FCM listen ${message.notification?.title}');
        debugPrint('FCM listen ${message.notification?.body}');
        // Parse the message received
        PushNotification notification = PushNotification(
          title: message.notification?.title,
          body: message.notification?.body,
        );

        setState(() {
          _notificationInfo = notification;
          debugPrint('FCM _totalNotifications ${notification.toString()}');
        });

        showSimpleNotification(
          Text(
            _notificationInfo?.title ?? "---",
            style: const TextStyle(fontSize: DimenConstants.txtLarge),
          ),
          // leading: Text(
          //   "$_totalNotifications",
          //   style: const TextStyle(fontSize: DimenConstants.txtLarge),
          // ),
          subtitle: Text(
            _notificationInfo?.body ?? "---",
            style: const TextStyle(fontSize: DimenConstants.txtMedium),
          ),
          background: Colors.green,
          duration: const Duration(seconds: 10),
        );
      });
    } else {
      debugPrint('FCM User declined or has not accepted permission');
    }
  }

  void _setupListen() {
    _controller.appLoading.listen((appLoading) {});
    _controller.appError.listen((err) {});
  }

  @override
  void dispose() {
    _controller.clearOnDispose();
    _navigationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 0,
          backgroundColor: ColorConstants.appColor,
        ),
        body: Obx(() {
          return Column(
            children: [
              ProfileBarWidget(
                name: _controller.getName(),
                state: "⬤ Online",
                linkAvatar: _controller.getAvatar(),
              ),
              Expanded(
                child: Stack(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(bottom: bottomNavBarHeight),
                      child: bodyContainer(),
                    ),
                    Align(alignment: Alignment.bottomCenter, child: bottomNav())
                  ],
                ),
              )
            ],
          );
        }));
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

    return Container(
      width: double.infinity,
      height: double.infinity,
      color: selectedColor,
      child: buildPage(),
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
}
