import 'package:chat_app/models/comment.dart';
import 'package:chat_app/utils/colors.dart';
import 'package:chat_app/widgets/published_date.dart';
import 'package:flutter/material.dart';

class CommentCard extends StatefulWidget {
  final CommentModel comment;

  const CommentCard({
    super.key,
    required this.comment,
  });

  @override
  State<StatefulWidget> createState() => _CommentCard();
}

class _CommentCard extends State<CommentCard> {
  @override
  Widget build(Object context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 18,
              backgroundImage: NetworkImage(widget.comment.userDpUrl),
            ),
            Expanded(
                child: Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  RichText(
                      text: TextSpan(children: [
                    TextSpan(
                        text: widget.comment.username,
                        style: const TextStyle(
                            color: primaryTextColor,
                            fontWeight: FontWeight.bold)),
                    TextSpan(
                      style: const TextStyle(
                        color: hintTextColor,
                      ),
                      text: "   ${widget.comment.comment}",
                    ),
                  ])),
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: PublishedDate(
                      date: widget.comment.datePublished,
                    ),
                  )
                ],
              ),
            )),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: const Icon(
                Icons.favorite,
                color: primaryTextColor,
              ),
            )
          ]),
    );
  }
}
