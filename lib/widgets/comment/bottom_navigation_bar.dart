import 'package:chat_app/firebase/firestore/firestore_methods.dart';
import 'package:chat_app/utils/colors.dart';
import 'package:chat_app/utils/snackbar.dart';
import 'package:flutter/material.dart';

class CommentBottomNavigationBar extends StatefulWidget {
  final String userDpUrl;
  final String userName;
  final String postId;
  final String uid;

  const CommentBottomNavigationBar(
      {super.key,
      required this.userName,
      required this.userDpUrl,
      required this.postId,
      required this.uid});

  @override
  State<StatefulWidget> createState() => _CommentBottomNavigationBar();
}

class _CommentBottomNavigationBar extends State<CommentBottomNavigationBar> {
  final TextEditingController _commentController = TextEditingController();

  void commentOnPost(dynamic context) async {
    final String res = await FirestoreMethods().commentOnPost(
        comment: _commentController.text,
        postId: widget.postId,
        uid: widget.uid,
        username: widget.userName,
        userDpUrl: widget.userDpUrl);
    if (res.isNotEmpty) {
      showSnackbar(res, context);
    } else {
      setState(() {
        _commentController.text = '';
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    _commentController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Container(
      height: kToolbarHeight,
      margin: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      padding: const EdgeInsets.only(left: 16, right: 8),
      child: Row(children: [
        CircleAvatar(
          radius: 18,
          backgroundImage: NetworkImage(widget.userDpUrl),
        ),
        Expanded(
            child: Padding(
          padding: const EdgeInsets.only(left: 16, right: 16),
          child: TextField(
            controller: _commentController,
            maxLines: 8,
            style: const TextStyle(color: primaryTextColor),
            decoration: InputDecoration(
                hintStyle: const TextStyle(color: hintTextColor),
                hintText: "Comment as ${widget.userName}",
                border: InputBorder.none),
          ),
        )),
        InkWell(
          onTap: () {
            commentOnPost(context);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
            child: const Text(
              "Post",
              style: TextStyle(color: primaryColor),
            ),
          ),
        )
      ]),
    ));
  }
}
