import 'package:chat_app/screens/login_screen.dart';
import 'package:chat_app/utils/colors.dart';
import 'package:flutter/material.dart';

class WebScreenLayout extends StatelessWidget {
  const WebScreenLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Theme(
        data: ThemeData.dark().copyWith(scaffoldBackgroundColor: webBgColor),
        child: const Scaffold(
          body: LoginScreen(),
        ));
  }
}
