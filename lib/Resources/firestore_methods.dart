import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:sociagram/models/post.dart';
import 'package:sociagram/Resources/storage_methods.dart';
import 'package:uuid/uuid.dart';

class FireStoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //post a pic in the app
  Future<String> uploadPost(String description, Uint8List file, String uid,
      String username, String profImage) async {
    String res = "Some error occured";

    try {
      String photoURL =
          await StorageMethods().uploadImageToStorage('post', file, true);
      String postId = const Uuid().v1();
      Post post = Post(
        description: description,
        uid: uid,
        username: username,
        likes: [],
        postId: postId,
        datePublished: DateTime.now(),
        postURL: photoURL,
        profImage: profImage,
      );
      _firestore.collection('post').doc(postId).set(post.toJson());
      res = "success";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  //update likes
  Future<String> likePost(String postId, String uid, List likes) async {
    String res = "Some error has ocured";
    try {
      if (likes.contains(uid)) {
        //if the likes contains the uer uid, we need to remove it
        _firestore.collection('post').doc(postId).update({
          'likes': FieldValue.arrayRemove([uid])
        });
      } else {
        //else we need to add uid to the likes array
        _firestore.collection('post').doc(postId).update({
          'likes': FieldValue.arrayUnion([uid])
        });
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  //post comment
  Future<String> postComment(String postId, String text, String uid,
      String name, String profilePic) async {
    String res = "Some error has occurred";
    try {
      if (text.isNotEmpty) {
        //if the likes list contains the user uid, we need to remove it
        String commentId = const Uuid().v1();
        _firestore
            .collection('post')
            .doc(postId)
            .collection('Comments')
            .doc(commentId)
            .set({
          'profilePic': profilePic,
          'name': name,
          'uid': uid,
          'text': text,
          'commentId': commentId,
          'datePublished': DateTime.now(),
        });
        res = 'success';
      } else {
        res = 'Please enter text';
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  //delete post
  Future<String> deletePost(String postId) async {
    String res = 'Some error has occurred';
    try {
      await _firestore.collection('post').doc(postId).delete();
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  //update following
  Future<void> followUser(String uid, String followId) async {
    try {
      DocumentSnapshot snap =
          await _firestore.collection('users').doc(uid).get();
      List follwing = (snap.data()! as dynamic)['following'];

      if (follwing.contains(followId)) {
        await _firestore.collection('users').doc(followId).update({
          'followers': FieldValue.arrayRemove([uid])
        });
        await _firestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayRemove([followId])
        });
      } else {
        await _firestore.collection('users').doc(followId).update({
          'followers': FieldValue.arrayUnion([uid])
        });

        await _firestore.collection('users').doc(followId).update({
          'followers': FieldValue.arrayUnion([followId])
        });
      }
    } catch (e) {
      if (kDebugMode) print(e.toString());
    }
  }
}
