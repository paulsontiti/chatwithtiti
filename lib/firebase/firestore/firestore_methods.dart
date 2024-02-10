import 'package:chat_app/firebase/storage/storage_method.dart';
import 'package:chat_app/models/comment.dart';
import 'package:chat_app/models/post.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

class FirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> uploadPost(String description, Uint8List file, String uid,
      String username, String userDpUrl) async {
    String res = "some error occured";
    try {
      String postUrl = await StorageMethods()
          .uploadFileToFirebaseStorage('posts', file, true);
      String postId = const Uuid().v1();
      PostModel post = PostModel(
          likes: [],
          username: username,
          description: description,
          postId: postId,
          uid: uid,
          datePublished: DateTime.now(),
          postUrl: postUrl,
          userDpUrl: userDpUrl);

      _firestore.collection('posts').doc(postId).set(post.toJson());
      res = "success";
    } catch (err) {
      res = err.toString();
    }

    return res;
  }

  Future<String> likePost(
      {required String postId,
      required String uid,
      required List likes}) async {
    String res = "";
    try {
      if (likes.contains(uid)) {
        await _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayRemove([uid])
        });
      } else {
        await _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayUnion([uid])
        });
      }
    } catch (e) {
      res = "Sorry an error occured. Please try again";
    }
    return res;
  }

  Future<String> deletePost({required String postId}) async {
    try {
      await _firestore.collection('posts').doc(postId).delete();
      return "";
    } catch (e) {
      return "Sorry an error occured. Please try again";
    }
  }

  Future<String> followUser(
      {required String followingId, required String followerId}) async {
    try {
      DocumentReference<Map<String, dynamic>> followerDocRef =
          _firestore.collection('users').doc(followerId);
      DocumentReference<Map<String, dynamic>> followingDocRef =
          _firestore.collection('users').doc(followingId);

      DocumentSnapshot<Map<String, dynamic>> snap = await followerDocRef.get();
      List followers = snap['followers'];

      if (followers.contains(followingId)) {
        await followerDocRef.update({
          'followers': FieldValue.arrayRemove([followingId])
        });
        await followingDocRef.update({
          'following': FieldValue.arrayRemove([followerId])
        });
      } else {
        await followerDocRef.update({
          'followers': FieldValue.arrayUnion([followingId])
        });
        await followingDocRef.update({
          'following': FieldValue.arrayUnion([followerId])
        });
      }
      return "";
    } catch (e) {
      return "Sorry an error occured. Please try again";
    }
  }

  Future<String> commentOnPost(
      {required comment,
      required String postId,
      required String uid,
      required String username,
      required String userDpUrl}) async {
    try {
      if (comment.isNotEmpty) {
        String commentId = const Uuid().v1();
        CommentModel postComment = CommentModel(
            likes: [],
            username: username,
            comment: comment,
            postId: postId,
            uid: uid,
            datePublished: DateTime.now(),
            userDpUrl: userDpUrl);

        _firestore
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .set(postComment.toJson());
        return '';
      } else {
        return "Please type your comment";
      }
    } catch (err) {
      return err.toString();
    }
  }
}
