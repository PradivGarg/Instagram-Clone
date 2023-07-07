import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String description;
  final String uid;
  final String username;
  final likes;
  final String postId;
  final DateTime datePublished;
  final String postURL;
  final String profImage;

  const Post({
    required this.description,
    required this.uid,
    required this.username,
    required this.likes,
    required this.postId,
    required this.datePublished,
    required this.postURL,
    required this.profImage,
  });

  static Post fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return Post(
        description: snapshot['description'],
        uid: snapshot["userId"],
        likes: snapshot['likes'],
        postId: snapshot['postID'],
        datePublished: snapshot['datePublished'],
        username: snapshot['username'],
        postURL: snapshot['postURL'],
        profImage: snapshot['profImage']);
  }

  Map<String, dynamic> toJson() => {
        "description": description,
        "uid": uid,
        "likes": likes,
        "username": username,
        "PostId": postId,
        "datePublished": datePublished,
        "postURL": postURL,
        "profImage": profImage
      };
}
