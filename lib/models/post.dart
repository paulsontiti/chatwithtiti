import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  final String description;
  final String uid;
  final String username;
  final String postId;
  final DateTime datePublished;
  final String postUrl;
  final String userDpUrl;
  final List likes;

  const PostModel({
    required this.likes,
    required this.username,
    required this.description,
    required this.postId,
    required this.uid,
    required this.datePublished,
    required this.postUrl,
    required this.userDpUrl,
  });

  static PostModel? fromDocumentSnapshot(DocumentSnapshot snapshot) {
    if (snapshot.data() == null) return null;
    var snap = snapshot.data() as Map<String, dynamic>;
    return PostModel(
        username: snap['username'],
        description: snap['description'],
        postId: snap['postId'],
        uid: snap['uid'],
        datePublished: snap['datePublished'].toDate(),
        postUrl: snap['postUrl'],
        userDpUrl: snap['userDpUrl'],
        likes: snap['likes']);
  }

  Map<String, dynamic> toJson() => {
        'description': description,
        'username': username,
        'postId': postId,
        'uid': uid,
        'datePublished': datePublished,
        'postUrl': postUrl,
        'userDpUrl': userDpUrl,
        'likes': likes
      };
}
