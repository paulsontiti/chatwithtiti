import 'package:chat_app/utils/colors.dart';
import 'package:chat_app/widgets/post_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PostScreen extends StatelessWidget {
  final QueryDocumentSnapshot<Map<String, dynamic>> snap;

  const PostScreen({super.key, required this.snap});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBgColor,
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: primaryColor,
            )),
        title: const Text(
          'Post',
          style: TextStyle(color: primaryTextColor),
        ),
        centerTitle: false,
      ),
      body: PostCard(snap: snap),
    );
  }
}
