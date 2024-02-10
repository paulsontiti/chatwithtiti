import 'package:chat_app/models/post.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String username;
  final String email;
  final String bio;
  final String uid;
  final List followers;
  final List following;
  final String dpUrl;

  const UserModel({
    required this.username,
    required this.email,
    required this.bio,
    required this.uid,
    required this.followers,
    required this.following,
    required this.dpUrl,
  });

  Future<int> numberOfuserPost() async {
    var snap = await FirebaseFirestore.instance.collection('posts').get();

    return snap.docs
        .where(
            (snapshot) => PostModel.fromDocumentSnapshot(snapshot)?.uid == uid)
        .length;
  }

  static UserModel? fromDocumentSnapshot(DocumentSnapshot snapshot) {
    if (snapshot.data() == null) return null;
    var snap = snapshot.data() as Map<String, dynamic>;
    return UserModel(
        username: snap['username'],
        email: snap['email'],
        bio: snap['bio'],
        uid: snap['uid'],
        followers: snap['followers'],
        following: snap['following'],
        dpUrl: snap['dpUrl']);
  }

  Map<String, dynamic> toJson() => {
        'email': email,
        'username': username,
        'bio': bio,
        'uid': uid,
        'followers': followers,
        'following': following,
        'dpUrl': dpUrl,
      };
}
