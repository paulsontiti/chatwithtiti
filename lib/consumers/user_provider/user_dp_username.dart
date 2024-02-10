import 'package:chat_app/models/user.dart';
import 'package:chat_app/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserDpUserName extends StatefulWidget {
  final bool showUserName;
  const UserDpUserName(
    this.showUserName, {
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _UserDpState();
}

class _UserDpState extends State<UserDpUserName> {
  @override
  Widget build(BuildContext context) {
    UserModel? user = Provider.of<UserProvider>(context).getUser;
    final userName = user == null ? " " : user.username;
    final dpUrl = user == null ? " " : user.dpUrl;
    return Container(
      margin: const EdgeInsets.only(top: 10),
      child: Row(
        children: [
          dpUrl == ""
              ? const CircleAvatar(
                  radius: 20,
                  backgroundImage: AssetImage("assets/images/dp.png"),
                )
              : CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(dpUrl),
                ),
          //CachedNetworkImageWidget(url: dpUrl, height: 50, width: 50),
          widget.showUserName
              ? Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        userName,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      )
                    ],
                  ))
              : const Text(""),
        ],
      ),
    );
  }
}
