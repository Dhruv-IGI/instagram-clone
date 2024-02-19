import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/user.dart';
import '../providers/user_provider.dart';
import '../resources/firestore_methods.dart';
import 'like_animation.dart';

class CommentCard extends StatefulWidget {
  final snap;
  final String postId;
  final String commentId;
  const CommentCard({super.key, required this.snap, required this.postId, required this.commentId});

  @override
  State<CommentCard> createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context).getUser;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundImage: NetworkImage(widget.snap['profilePic']),
          ),
          Expanded(
            child: Padding(padding: const EdgeInsets.only(left: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: widget.snap['name'],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: ' ${widget.snap['text']}',
                        ),
                      ],
                    ),
                  ),
                  Padding(padding: const EdgeInsets.only(top: 4),
                    child: Text(DateFormat.yMMMd().format(DateTime.parse(widget.snap['date'])), style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),),),
                ],
              ),),
          ),
            Container(
              child: Column(
                children: [
                  LikeAnimation(
                    isAnimating: widget.snap['likes'].contains(user.uid),
                    smallLike: true,
                    child: IconButton(
                        onPressed: () async {
                          print(user.uid);
                          print(widget.snap);
                          await FireStoreMethods().likeComment(widget.postId,
                              widget.commentId, user.uid, widget.snap['likes']);
                        },
                        icon: widget.snap['likes'].contains(user.uid)? const Icon(
                          Icons.favorite,
                          color: Colors.red,
                        ) : const Icon(
                          Icons.favorite_border,
                        )
                    ),
                  ),
                  Text(
                    '${widget.snap['likes'].length} likes',
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            )
        ],
      ),
    );
  }
}

