import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rapido/models/post.dart';
import 'package:rapido/ressources/storage_methods.dart';
import 'package:uuid/uuid.dart';

class FirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // upload post
  Future<String> uploadPost(
    String description,
    Uint8List file,
    String uid,
    String username,
    String profImage,
  ) async {
    String res = "Some error occured";
    try {
      String photoUrl =
          await StorageMethods().uploadImageToStorage('posts', file, true);
      String postId = const Uuid().v1();
      Post post = Post(
          description: description,
          uid: uid,
          username: username,
          postId: postId,
          datePublished: DateTime.now().toString(),
          postUrl: photoUrl,
          profImage: profImage,
          likes: []);

      _firestore.collection('posts').doc(postId).set(post.toJson());
      res = "Post uploaded successfully";
    } catch (e) {
      return e.toString();
    }
    return res;
  }

  Future<void> likePost(String postId, String uid, List likes ) async {
    try {
      if(likes.contains(uid)) {
        await _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayRemove([uid])
        });
      } else {
        await _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayUnion([uid])
        });
      }
    } catch (e) {
      print(e.toString());
    }

    // DocumentSnapshot<Map<String, dynamic>> post =
    //     await _firestore.collection('posts').doc(postId).get();
    // List<dynamic> postLikes = post.data()!['likes'];
    // if (likes.contains(uid)) {
    //   likes.remove(uid);
    // } else {
    //   likes.add(uid);
    // }
    // _firestore.collection('posts').doc(postId).update({'likes': postLikes});
  }
}
