import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String description;
  final String uid;
  final String postId;
  final String username;
  final datePublished;
  final String postUrl;
  final String profImage;
  final likes;

  Post({
    required this.description,
    required this.uid,
    required this.postId,
    required this.username,
    required this.datePublished,
    required this.postUrl,
    required this.profImage,
    required this.likes,
  });

  Map<String, dynamic> toJSON() {
    return {
      'description': description,
      'uid': uid,
      'postUrl': postUrl,
      'username': username,
      'datePublished': datePublished,
      'profImage': profImage,
      'likes': likes,
      'postId': postId,
    };
  }

  static Post fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    print(snapshot);
    return Post(
      username: snapshot["username"],
      uid: snapshot["uid"],
      description: snapshot["description"],
      postUrl: snapshot["postUrl"],
      datePublished: snapshot["datePublished"],
      likes: snapshot["likes"],
      profImage: snapshot["profImage"],
      postId: snapshot["postId"],
    );
  }

}
