import 'package:chat_app/models/comment.dart';
import 'package:chat_app/models/user.dart';
import 'package:chat_app/providers/user_provider.dart';
import 'package:chat_app/utils/colors.dart';
import 'package:chat_app/widgets/comment/bottom_navigation_bar.dart';
import 'package:chat_app/widgets/comment/comment_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CommentScreen extends StatefulWidget {
  final DocumentSnapshot snap;
  const CommentScreen({super.key, required this.snap});

  @override
  State<StatefulWidget> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  @override
  Widget build(BuildContext context) {
    UserModel? user = Provider.of<UserProvider>(context).getUser;

    return Scaffold(
      backgroundColor: mobileBgColor,
      appBar: AppBar(
        backgroundColor: mobileBgColor,
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: primaryTextColor,
            )),
        title: const Text(
          "Comments",
          style: TextStyle(
            color: primaryTextColor,
          ),
        ),
        centerTitle: false,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('posts')
            .doc(widget.snap['postId'])
            .collection('comments')
            .orderBy('datePublished', descending: true)
            .snapshots(),
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return ListView.builder(
              itemCount: snapshot.data?.docs.length,
              itemBuilder: (context, index) {
                return CommentCard(
                  comment: CommentModel.fromQueryDocumentSnapshot(
                      snapshot.data?.docs[index])!,
                );
              });
        },
      ),
      bottomNavigationBar: CommentBottomNavigationBar(
        userDpUrl: user!.dpUrl,
        userName: user.username,
        postId: widget.snap['postId'],
        uid: user.uid,
      ),
    );
  }
}
