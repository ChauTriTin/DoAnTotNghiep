import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import 'welcome_screen.dart';

class signUpScreen extends StatefulWidget {
  const signUpScreen({super.key});

  @override
  State<signUpScreen> createState() => _signUpScreenState();
}

class _signUpScreenState extends State<signUpScreen> {
  @override
  TextEditingController txtEmail = TextEditingController();
  TextEditingController txtPass = TextEditingController();
  TextEditingController txtPass2 = TextEditingController();
  TextEditingController txtName = TextEditingController();
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
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => welcomeScreen(),
                      ),
                    );
                  },
                  child: Image.asset(
                    'images/backSignUp.png',
                    height: h * 0.2,
                  ),
                ),
              ],
            ),
            Spacer(),
            Container(
              width: w,
              height: h * 0.65,
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'ĐĂNG KÝ',
                    style: TextStyle(
                        fontSize: _fontSize() + 5, fontWeight: FontWeight.w500),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 20, left: 20, right: 20),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.red[900],
                        border: Border.all(width: 2, color: Colors.white),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 5.0),
                        child: TextField(
                          style: TextStyle(color: Colors.white),
                          controller: txtEmail,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              labelText: 'Tên người dùng',
                              labelStyle: TextStyle(color: Colors.white),
                              prefixIcon: Icon(
                                Icons.person_outline,
                                color: Colors.white,
                              )),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 20, left: 20, right: 20),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.red[900],
                        border: Border.all(width: 2, color: Colors.white),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 5.0),
                        child: TextField(
                          style: TextStyle(color: Colors.white),
                          controller: txtEmail,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              labelText: 'Email',
                              labelStyle: TextStyle(color: Colors.white),
                              prefixIcon: Icon(
                                Icons.email,
                                color: Colors.white,
                              )),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 20, left: 20, right: 20),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.red[900],
                        border: Border.all(width: 2, color: Colors.white),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: TextField(
                        obscureText: true, //ẩn password
                        style: TextStyle(color: Colors.white),
                        controller: txtPass,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            labelText: 'Mật khẩu',
                            labelStyle: TextStyle(color: Colors.white),
                            prefixIcon: Icon(
                              Icons.password,
                              color: Colors.white,
                            )),
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 20, left: 20, right: 20),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.red[900],
                        border: Border.all(width: 2, color: Colors.white),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: TextField(
                        obscureText: true, //ẩn password
                        style: TextStyle(color: Colors.white),
                        controller: txtPass2,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            labelText: 'Nhập lại mật khẩu',
                            labelStyle: TextStyle(color: Colors.white),
                            prefixIcon: Icon(
                              Icons.password,
                              color: Colors.white,
                            )),
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 20, left: 20, right: 20),
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        minimumSize: Size(w * 0.7, w * 0.15),
                        backgroundColor: Colors.black,
                        side: BorderSide(color: Colors.white, width: 2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      onPressed: () {
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) => MyApp(),
                        //   ),
                        // );
                      },
                      child: Text(
                        'ĐĂNG KÝ',
                        style: TextStyle(
                            fontSize: _fontSize() - 5, color: Colors.white),
                      ),
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
