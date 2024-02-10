import 'package:chat_app/screens/add_post_screen.dart';
import 'package:chat_app/screens/feed_screen.dart';
import 'package:chat_app/screens/profile_screen.dart';
import 'package:chat_app/screens/search_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

const int xs = 300;
const int sm = 599;
const int md = 899;
const int lg = 1199;
const int xl = 1200;

List<Widget> homeScreens = [
  const FeedScreen(),
  const AddPostScreen(),
  ProfileScreen(uid: FirebaseAuth.instance.currentUser?.uid as String),
  const SearchScreen(),
  const Center(
    child: Text("Notifications"),
  ),
];
