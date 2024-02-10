import 'package:chat_app/firebase/auth/auth_methods.dart';
import 'package:chat_app/firebase/firestore/firestore_methods.dart';
import 'package:chat_app/models/user.dart';
import 'package:chat_app/providers/user_provider.dart';
import 'package:chat_app/screens/post_screen.dart';
import 'package:chat_app/utils/colors.dart';
import 'package:chat_app/utils/snackbar.dart';
import 'package:chat_app/widgets/follow_button.dart';
import 'package:chat_app/widgets/user_stat.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  final String uid;
  const ProfileScreen({super.key, required this.uid});

  @override
  State<StatefulWidget> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  UserModel? user;
  int numberOfPost = 0;
  bool isFollowing = false;
  int followers = 0;
  @override
  void initState() {
    super.initState();
    getUserData();
  }

  getUserData() async {
    try {
      var userSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)
          .get();
      var postSnap = await FirebaseFirestore.instance
          .collection('posts')
          .where('uid', isEqualTo: widget.uid)
          .get();

      setState(() {
        user = UserModel.fromDocumentSnapshot(userSnap);
        numberOfPost = postSnap.docs.length;
        followers = user!.followers.length;
        isFollowing = user != null &&
            user?.followers.contains(FirebaseAuth.instance.currentUser!.uid)
                as bool;
        // .where((element) =>
        //     PostModel.fromDocumentSnapshot(element)?.uid == widget.uid)
        // .length;
      });
    } catch (e) {
      // ignore: use_build_context_synchronously
      showSnackbar(e.toString(), context);
    }
  }

  @override
  Widget build(BuildContext context) {
    UserModel currentUser = Provider.of<UserProvider>(context).getUser!;
    bool isUserAccount = user?.uid == FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
        backgroundColor: mobileBgColor,
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: primaryColor,
            ),
          ),
          title: Text(
            currentUser.username,
            style: const TextStyle(color: primaryTextColor),
          ),
          centerTitle: false,
          backgroundColor: mobileBgColor,
        ),
        body: user == null
            ? const Center(child: CircularProgressIndicator())
            : ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                radius: 40,
                                backgroundImage:
                                    NetworkImage(user?.dpUrl as String),
                              ),
                              Expanded(
                                  child: Column(
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      UserStat(
                                        value: numberOfPost,
                                        label: 'posts',
                                      ),
                                      UserStat(
                                        value: followers,
                                        label: 'followers',
                                      ),
                                      UserStat(
                                        value: user!.following.length,
                                        label: 'following',
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      isUserAccount
                                          ? FollowButton(
                                              function: () async {
                                                String res = await AuthMethods()
                                                    .signOut();
                                                if (res.isNotEmpty) {
                                                  showSnackbar(res, context);
                                                }
                                              },
                                              bgColor: primaryColor,
                                              borderColor: secondaryColor,
                                              text: "Sign Out",
                                              textColor: primaryTextColor)
                                          : isFollowing
                                              ? FollowButton(
                                                  function: () async {
                                                    await FirestoreMethods()
                                                        .followUser(
                                                            followingId:
                                                                currentUser.uid,
                                                            followerId:
                                                                user!.uid);
                                                    setState(() {
                                                      isFollowing = false;
                                                      followers--;
                                                    });
                                                  },
                                                  bgColor: secondaryColor,
                                                  borderColor: primaryColor,
                                                  text: "Unfollow",
                                                  textColor: primaryColor)
                                              : FollowButton(
                                                  function: () async {
                                                    await FirestoreMethods()
                                                        .followUser(
                                                            followingId:
                                                                currentUser.uid,
                                                            followerId:
                                                                user!.uid);
                                                    setState(() {
                                                      isFollowing = true;
                                                      followers++;
                                                    });
                                                  },
                                                  bgColor: primaryColor,
                                                  borderColor: secondaryColor,
                                                  text: "Follow",
                                                  textColor: primaryTextColor)
                                    ],
                                  )
                                ],
                              )),
                            ]),
                        Container(
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.only(top: 15),
                            child: Text(
                              user!.username,
                              style: const TextStyle(
                                  color: primaryTextColor,
                                  fontWeight: FontWeight.bold),
                            )),
                        Container(
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.only(top: 2),
                            child: Text(
                              user!.bio,
                              style: const TextStyle(color: primaryTextColor),
                            ))
                      ],
                    ),
                  ),
                  const Divider(color: primaryColor),
                  FutureBuilder(
                      future: FirebaseFirestore.instance
                          .collection('posts')
                          .where('uid', isEqualTo: widget.uid)
                          .get(),
                      builder: ((context,
                          AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                              snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (!snapshot.hasData) {
                          return const Center(
                            child: Text("No Posts available"),
                          );
                        } else {
                          return GridView.builder(
                              shrinkWrap: true,
                              itemCount: snapshot.data!.docs.length,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3,
                                      crossAxisSpacing: 5,
                                      mainAxisSpacing: 1.5,
                                      childAspectRatio: 1),
                              itemBuilder: (context, index) {
                                QueryDocumentSnapshot<Map<String, dynamic>>
                                    snap = snapshot.data!.docs[index];
                                return InkWell(
                                  //padding: const EdgeInsets.all(4),
                                  onTap: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                PostScreen(snap: snap)));
                                  },
                                  child: Image(
                                      fit: BoxFit.cover,
                                      image: NetworkImage(snap['postUrl'])),
                                );
                              });
                        }
                      }))
                ],
              ));
  }
}
