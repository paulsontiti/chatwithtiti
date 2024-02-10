import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ViewPostComment extends StatelessWidget {
  final String postId;
  const ViewPostComment({super.key, required this.postId});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('posts')
          .doc(postId)
          .collection('comments')
          .snapshots(),
      builder: (context,
          AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return Text(
          snapshot.data!.docs.isEmpty
              ? ""
              : 'View all ${snapshot.data?.docs.length} comments',
          style: const TextStyle(fontSize: 16, color: Colors.grey),
        );
      },
    );
  }
}
