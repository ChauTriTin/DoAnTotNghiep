import 'package:appdiphuot/old/screen/welcome_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import '../login.dart';

class loginScreen extends StatefulWidget {
  const loginScreen({super.key});

  @override
  State<loginScreen> createState() => _loginScreenState();
}

class _loginScreenState extends State<loginScreen> {
  @override
  TextEditingController txtEmail = TextEditingController();
  TextEditingController txtPass = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  Services service = Services();
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
                    'images/backLogin.png',
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
                color: Colors.red[700],
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'ĐĂNG NHẬP',
                    style: TextStyle(
                        fontSize: _fontSize() + 5, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(
                    height: h * 0.05,
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
                        if (txtEmail.text.isNotEmpty ||
                            txtPass.text.isNotEmpty) {
                          service.loginUser(
                              txtEmail.text, txtPass.text, context);
                        } else {
                          final snackBar = SnackBar(
                              content:
                                  Text('Tài khoản hoặc mật khẩu không đúng'));
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        }
                      },
                      child: Text(
                        'ĐĂNG NHẬP',
                        style: TextStyle(
                            fontSize: _fontSize() - 5, color: Colors.white),
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 20, left: 20, right: 20),
                    child: GestureDetector(
                      onTap: () {},
                      child: Text(
                        'QUÊN MẬT KHẨU',
                        style: TextStyle(
                          fontSize: _fontSize() - 8,
                          color: Colors.white54,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text(
                      'HOẶC ĐĂNG NHẬP BẰNG',
                      style: TextStyle(
                        fontSize: _fontSize() - 8,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () {},
                          child: Image.asset(
                            'images/google.png',
                            height: h * 0.05,
                          ),
                        ),
                        SizedBox(
                          width: w * 0.1,
                        ),
                        InkWell(
                          onTap: () {},
                          child: Image.asset(
                            'images/facebook.png',
                            height: h * 0.05,
                          ),
                        ),
                      ],
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
