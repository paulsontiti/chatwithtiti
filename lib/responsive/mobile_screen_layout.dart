import 'package:chat_app/consumers/user_provider/user_dp_username.dart';

import 'package:chat_app/utils/colors.dart';
import 'package:chat_app/utils/global.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MobileScreenLayout extends StatefulWidget {
  const MobileScreenLayout({super.key});

  @override
  State<StatefulWidget> createState() => _MobileScreenState();
}

class _MobileScreenState extends State<MobileScreenLayout> {
  int _page = 0;
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
        data: ThemeData.dark().copyWith(scaffoldBackgroundColor: mobileBgColor),
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: mobileBgColor,
            leading: const IconButton(
              icon: Icon(Icons.menu),
              tooltip: 'Navigation menu',
              onPressed: null,
            ),
            title: const Text('BEAUTIFULS'),
            actions: const [
              UserDpUserName(true),
              IconButton(
                icon: Icon(Icons.search),
                tooltip: 'Search',
                onPressed: null,
              ),
            ],
          ),
          body: PageView(
              controller: pageController,
              onPageChanged: pageChangedHandler,
              children: homeScreens),
          bottomNavigationBar: CupertinoTabBar(
            backgroundColor: mobileBgColor,
            items: [
              BottomNavigationBarItem(
                  icon: Icon(Icons.home,
                      color: _page == 0 ? primaryColor : secondaryColor),
                  label: "Home",
                  backgroundColor: primaryColor),
              BottomNavigationBarItem(
                  icon: Icon(Icons.add_a_photo,
                      color: _page == 1 ? primaryColor : secondaryColor),
                  label: "Post",
                  backgroundColor: primaryColor),
              BottomNavigationBarItem(
                  icon: Icon(Icons.person,
                      color: _page == 2 ? primaryColor : secondaryColor),
                  label: "Account",
                  backgroundColor: primaryColor),
              BottomNavigationBarItem(
                  icon: Icon(Icons.search,
                      color: _page == 3 ? primaryColor : secondaryColor),
                  label: "Search",
                  backgroundColor: primaryColor),
              BottomNavigationBarItem(
                  icon: Icon(Icons.notifications,
                      color: _page == 4 ? primaryColor : secondaryColor),
                  label: "Notifications",
                  backgroundColor: primaryColor)
            ],
            onTap: handleNavigation,
          ),
        ));
  }
}
