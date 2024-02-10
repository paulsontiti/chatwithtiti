import 'package:chat_app/utils/colors.dart';
import 'package:chat_app/utils/global.dart';
import 'package:chat_app/widgets/post_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final bool isWeb = width > sm;
    return Scaffold(
      appBar: width > sm
          ? null
          : AppBar(
              backgroundColor: isWeb ? webBgColor : mobileBgColor,
              actions: const [
                IconButton(
                    onPressed: null,
                    icon: Icon(
                      Icons.messenger_outline_sharp,
                      color: Colors.white,
                    ))
              ],
              centerTitle: false,
              title: SvgPicture.asset(
                "assets/images/logo.svg",
                colorFilter:
                    const ColorFilter.mode(primaryColor, BlendMode.srcIn),
                height: 64,
              ),
            ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('posts').snapshots(),
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text('No posts yet. Be the first to post'),
            );
          } else {
            return ListView.builder(
                itemCount: snapshot.data?.docs.length,
                itemBuilder: (context, index) => Container(
                      margin: EdgeInsets.symmetric(
                          vertical: isWeb ? 15 : 0,
                          horizontal: isWeb ? width * 0.1 : 0),
                      child: PostCard(
                        snap: snapshot.data?.docs[index],
                      ),
                    ));
          }
        },
      ),
    );
  }
}
