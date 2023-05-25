import 'package:appdiphuot/old/screen/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  // WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '',
      home: Container(
        color: Colors.red,
        child: DoanApp(),
      ),
    );
  }
}

class DoanApp extends StatelessWidget {
  const DoanApp({super.key});

  @override
  Widget build(BuildContext context) {
    // return MaterialApp(
    //   theme: ThemeData.dark(),
    //   debugShowCheckedModeBanner: true,
    //   initialRoute:
    //       FirebaseAuth.instance.currentUser == null ? 'welcome' : 'home',
    //   routes: {
    //     'welcome': (context) => const loginScreen(),
    //     'home': (context) => const homeScreen(),
    //   },
    // );

    return MaterialApp(
      theme: ThemeData.dark(),
      debugShowCheckedModeBanner: true,
      home: const loginScreen(),
    );
  }
}
