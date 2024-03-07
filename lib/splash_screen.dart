import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'login.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Timer(const Duration(seconds: 2), () {
      Get.offAll(const Login());
    });
    return Scaffold(
      body: Center(
        child: Image.asset(
          'assets/images/softtouch_black.png',
          scale: 1.3,
        ),
      ),
    );
  }
}
