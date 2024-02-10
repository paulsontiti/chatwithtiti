import 'package:cloud_firestore/cloud_firestore.dart';

class CommentModel {
  final String comment;
  final String uid;
  final String username;
  final String postId;
  final DateTime datePublished;

  final String userDpUrl;
  final List likes;

  const CommentModel({
    required this.likes,
    required this.username,
    required this.comment,
    required this.postId,
    required this.uid,
    required this.datePublished,
    required this.userDpUrl,
  });

  static CommentModel? fromQueryDocumentSnapshot(
      QueryDocumentSnapshot<Map<String, dynamic>>? snapshot) {
    if (snapshot == null) return null;
    var snap = snapshot.data();
    return CommentModel(
        username: snap['username'],
        comment: snap['comment'],
        postId: snap['postId'],
        uid: snap['uid'],
        datePublished: snap['datePublished'].toDate(),
        userDpUrl: snap['userDpUrl'],
        likes: snap['likes']);
  }

  Map<String, dynamic> toJson() => {
        'comment': comment,
        'username': username,
        'postId': postId,
        'uid': uid,
        'datePublished': datePublished,
        'userDpUrl': userDpUrl,
        'likes': likes
      };
}
