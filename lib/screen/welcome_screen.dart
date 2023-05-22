import 'package:appdiphuot/screen/signup_srceen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import 'login_screen.dart';

class welcomeScreen extends StatefulWidget {
  const welcomeScreen({super.key});

  @override
  State<welcomeScreen> createState() => _welcomeScreenState();
}

class _welcomeScreenState extends State<welcomeScreen> {
  @override
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

  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'images/logo.png',
                  width: w,
                  height: h / 2.5,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'CÙNG BẠN TRÊN',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: _fontSize(),
                      fontWeight: FontWeight.bold,
                      letterSpacing: 3),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'NHỮNG HÀNG TRÌNH',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: _fontSize(),
                      fontWeight: FontWeight.bold,
                      letterSpacing: 3),
                ),
              ],
            ),
            Spacer(),
            Container(
              width: w,
              height: h * 0.4,
              decoration: BoxDecoration(
                color: Colors.red[700],
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      minimumSize: Size(w * 0.7, w * 0.15),
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
                          builder: (context) => loginScreen(),
                        ),
                      );
                    },
                    child: Text(
                      'ĐĂNG NHẬP',
                      style: TextStyle(
                          fontSize: _fontSize() - 5, color: Colors.white),
                    ),
                  ),
                  SizedBox(
                    height: w * 0.04,
                  ),
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      minimumSize: Size(w * 0.7, w * 0.15),
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
                          builder: (context) => signUpScreen(),
                        ),
                      );
                    },
                    child: Text(
                      'ĐĂNG KÝ',
                      style: TextStyle(
                          fontSize: _fontSize() - 5, color: Colors.white),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
