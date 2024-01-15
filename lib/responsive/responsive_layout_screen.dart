import 'package:chat_app/utils/dimension.dart';
import 'package:flutter/material.dart';

class ResponsiveLayout extends StatelessWidget {
  final Widget webScreenLayout;
  final Widget mobileScreenLayout;
  const ResponsiveLayout(
      {super.key,
      required this.webScreenLayout,
      required this.mobileScreenLayout});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, contraints) {
      if (contraints.maxWidth > webScreenSize) {
        return webScreenLayout;
      }
      return mobileScreenLayout;
    });
  }
}
