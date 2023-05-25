import 'package:appdiphuot/old/screen/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Services {
  final auth = FirebaseAuth.instance;
  loginUser(email, password, context) async {
    late String txtEmail;
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
      auth.authStateChanges().listen((event) {
        if (event != null) {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => homeScreen()));
        }
      });
    } catch (e) {
      final snackBar = SnackBar(content: Text('Lỗi kết nối đến Server'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }
}
