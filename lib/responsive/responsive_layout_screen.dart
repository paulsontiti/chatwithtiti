import 'package:chat_app/providers/user_provider.dart';
import 'package:chat_app/responsive/mobile_screen_layout.dart';
import 'package:chat_app/responsive/web_screen_layout.dart';
import 'package:chat_app/utils/global.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ResponsiveLayout extends StatefulWidget {
  final Widget webScreenLayout;
  final Widget mobileScreenLayout;
  const ResponsiveLayout(
      {super.key,
      required this.webScreenLayout,
      required this.mobileScreenLayout});

  @override
  State<StatefulWidget> createState() => _ResponsiveLayoutState();
}

class _ResponsiveLayoutState extends State<ResponsiveLayout> {
  @override
  void initState() {
    super.initState();
    addUserToState();
  }

  addUserToState() async {
    UserProvider userProvider = Provider.of(context, listen: false);

    await userProvider.refreshUser();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, contraints) {
      if (contraints.maxWidth > sm) {
        return const WebScreenLayout();
      }
      return const MobileScreenLayout();
    });
  }
}
