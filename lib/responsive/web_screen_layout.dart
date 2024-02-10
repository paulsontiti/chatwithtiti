import 'package:chat_app/consumers/user_provider/user_dp_username.dart';
import 'package:chat_app/screens/add_post_screen.dart';
import 'package:chat_app/screens/feed_screen.dart';
import 'package:chat_app/screens/profile_screen.dart';
import 'package:chat_app/screens/search_screen.dart';
import 'package:chat_app/utils/colors.dart';
import 'package:chat_app/utils/global.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class WebScreenLayout extends StatefulWidget {
  const WebScreenLayout({super.key});

  @override
  State<StatefulWidget> createState() => _WebSreenLayoutState();
}

class _WebSreenLayoutState extends State<WebScreenLayout> {
  final user = FirebaseAuth.instance.currentUser!;
  int _page = 0;
  String _body = 'home';
  late PageController pageController;

  @override
  void initState() {
    super.initState();
    pageController = PageController();
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  void handleNavigation(int page) {
    pageController.jumpToPage(page);
  }

  void pageChangedHandler(int page) {
    setState(() {
      _page = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
        data: ThemeData.dark().copyWith(scaffoldBackgroundColor: webBgColor),
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: webBgColor,
            leading: const IconButton(
              icon: Icon(Icons.menu, color: primaryTextColor),
              tooltip: 'Navigation menu',
              onPressed: null,
            ),
            title: const Text('Peppy World'),
            actions: [
              const UserDpUserName(true),
              IconButton(
                icon: Icon(
                  Icons.home,
                  color: _page == 0 ? primaryColor : primaryTextColor,
                ),
                tooltip: 'Home',
                onPressed: () => handleNavigation(0),
              ),
              IconButton(
                icon: Icon(
                  Icons.add_a_photo,
                  color: _page == 1 ? primaryColor : primaryTextColor,
                ),
                tooltip: 'Upload photo',
                onPressed: () => handleNavigation(1),
              ),
              IconButton(
                icon: Icon(
                  Icons.person,
                  color: _page == 2 ? primaryColor : primaryTextColor,
                ),
                tooltip: 'Account',
                onPressed: () => handleNavigation(2),
              ),
              IconButton(
                icon: Icon(
                  Icons.search,
                  color: _page == 3 ? primaryColor : primaryTextColor,
                ),
                tooltip: 'Search',
                onPressed: () => handleNavigation(3),
              ),
              IconButton(
                icon: Icon(
                  Icons.notifications,
                  color: _page == 4 ? primaryColor : primaryTextColor,
                ),
                tooltip: 'Notifications',
                onPressed: () => handleNavigation(4),
              ),
            ],
          ),
          body: PageView(
              controller: pageController,
              onPageChanged: pageChangedHandler,
              children: homeScreens),
        ));
  }
}
