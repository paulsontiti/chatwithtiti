import 'package:chat_app/models/user.dart';
import 'package:chat_app/providers/user_provider.dart';
import 'package:chat_app/utils/colors.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PostTextButton extends StatefulWidget {
  final Function postImage;

  const PostTextButton({super.key, required this.postImage});

  @override
  State<StatefulWidget> createState() => _PostTextButton();
}

class _PostTextButton extends State<PostTextButton> {
  @override
  Widget build(BuildContext context) {
    UserModel? user = Provider.of<UserProvider>(context).getUser;
    final userName = user == null ? " " : user.username;
    final uid = user == null ? " " : user.uid;
    final dpUrl = user == null ? " " : user.dpUrl;
    return TextButton(
        onPressed: () => widget.postImage(uid, userName, dpUrl),
        child: const Text("Share",
            style: TextStyle(
                color: primaryColor,
                fontSize: 16,
                fontWeight: FontWeight.bold)));
  }
}
