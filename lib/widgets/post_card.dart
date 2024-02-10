import 'package:chat_app/firebase/firestore/firestore_methods.dart';
import 'package:chat_app/models/user.dart';
import 'package:chat_app/providers/user_provider.dart';
import 'package:chat_app/screens/comment_screen.dart';
import 'package:chat_app/utils/colors.dart';
import 'package:chat_app/utils/snackbar.dart';
import 'package:chat_app/widgets/comment/view_post_comments.dart';
import 'package:chat_app/widgets/like_animation.dart';
import 'package:chat_app/widgets/published_date.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PostCard extends StatefulWidget {
  final QueryDocumentSnapshot<Map<String, dynamic>>? snap;
  const PostCard({super.key, required this.snap});

  @override
  State<StatefulWidget> createState() => _PostcardState();
}

class _PostcardState extends State<PostCard> {
  bool isLikeAnimating = false;
  void likeAPost(UserModel user, dynamic snap, dynamic context) async {
    var res = await FirestoreMethods()
        .likePost(uid: user.uid, likes: snap['likes'], postId: snap['postId']);
    setState(() {
      isLikeAnimating = true;
    });
    if (res != "") {
      showSnackbar(res, context);
    }
  }

  void navigateToCommentScreen(DocumentSnapshot snap, dynamic context) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => CommentScreen(
              snap: snap,
            )));
  }

  void deletePost(String postId, dynamic context) async {
    String res = await FirestoreMethods().deletePost(postId: postId);
    if (res.isNotEmpty) {
      showSnackbar(res, context);
    } else {
      showSnackbar('Post deleted successfully', context);

      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final snap = widget.snap!;
    UserModel? user = Provider.of<UserProvider>(context).getUser;
    bool postLiked = snap['likes'].contains(user?.uid);
    int numberOfLikes = snap['likes'].length;

    //check if this user made the post
    final bool isUserPost = snap['username'] == user?.username;

    return Container(
      color: mobileBgColor,
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(children: [
        //Header section
        Container(
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16)
              .copyWith(right: 0),
          child: Row(children: [
            Expanded(
                child: Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(snap["userDpUrl"]),
                ),
                Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          snap['username'],
                          style: const TextStyle(
                              color: primaryTextColor,
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    ))
              ],
            )),
            isUserPost
                ? IconButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) => Dialog(
                                child: ListView(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16),
                                  shrinkWrap: true,
                                  children: [if (isUserPost) 'Delete']
                                      .map((e) => InkWell(
                                            onTap: () {
                                              deletePost(
                                                  snap['postId'], context);
                                            },
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 12,
                                                      horizontal: 16),
                                              child: Text(e),
                                            ),
                                          ))
                                      .toList(),
                                ),
                              ));
                    },
                    icon: const Icon(
                      Icons.more_vert,
                      color: Colors.white,
                    ))
                : Container()
          ]),
        ),
        //Image section
        GestureDetector(
          onDoubleTap: () {
            likeAPost(user!, snap, context);
          },
          child: Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.4,
                width: double.infinity,
                child: Image.network(
                  snap["postUrl"],
                  fit: BoxFit.cover,
                ),
              ),
              AnimatedOpacity(
                opacity: isLikeAnimating ? 1 : 0,
                duration: const Duration(milliseconds: 200),
                child: LikeAnimation(
                  isAnimating: isLikeAnimating,
                  duration: const Duration(milliseconds: 400),
                  onEnd: () {
                    setState(() {
                      isLikeAnimating = false;
                    });
                  },
                  child: const Icon(
                    Icons.favorite,
                    color: Colors.white,
                    size: 120,
                  ),
                ),
              )
            ],
          ),
        ),
        //LIKE COMMENT SECTION
        Row(
          children: [
            LikeAnimation(
              isAnimating: postLiked,
              child: IconButton(
                  onPressed: () {
                    likeAPost(user!, snap, context);
                  },
                  icon: postLiked
                      ? const Icon(
                          Icons.favorite,
                          color: primaryColor,
                        )
                      : const Icon(
                          Icons.favorite_border,
                          color: primaryTextColor,
                        )),
            ),
            IconButton(
                onPressed: () {
                  navigateToCommentScreen(snap, context);
                },
                icon: const Icon(
                  Icons.comment,
                  color: Colors.white,
                )),
            const IconButton(
                onPressed: null,
                icon: Icon(
                  Icons.send,
                  color: Colors.white,
                )),
            const Expanded(
                child: Align(
              alignment: Alignment.bottomRight,
              child: IconButton(
                  onPressed: null,
                  icon: Icon(color: Colors.white, Icons.bookmark_border)),
            ))
          ],
        ),
        //DESCRIPTION AND NUMBER OF COMMENTS
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DefaultTextStyle(
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(fontWeight: FontWeight.w800),
                child: Text(
                  numberOfLikes == 0
                      ? ""
                      : '$numberOfLikes ${numberOfLikes > 1 ? 'likes' : 'like'}',
                  style: const TextStyle(color: primaryTextColor),
                ),
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.only(top: 8),
                child: RichText(
                    text: TextSpan(
                        style: const TextStyle(color: Colors.white),
                        children: [
                      TextSpan(
                          text: snap['username'],
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      TextSpan(
                          text: " ${snap["description"]}",
                          style: const TextStyle(color: Colors.white70))
                    ])),
              ),
              InkWell(
                onTap: () {
                  navigateToCommentScreen(snap, context);
                },
                child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: ViewPostComment(postId: snap['postId'])),
              ),
              Container(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: PublishedDate(
                    date: snap['datePublished'].toDate(),
                  ))
            ],
          ),
        )
      ]),
    );
  }
}
