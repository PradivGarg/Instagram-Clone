import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sociagram/Resources/firestore_methods.dart';
import 'package:sociagram/providers/user_provider.dart';
import 'package:sociagram/utils/colors.dart';
import 'package:sociagram/utils/utils.dart';

import '../Widgets/commen_card.dart';
import '../models/user.dart';

class commentScreen extends StatefulWidget {
  final postId;
  const commentScreen({Key? key, required this.postId}) : super(key: key);

  @override
  _commentScreenState createState() => _commentScreenState();
}

class _commentScreenState extends State<commentScreen> {
  final TextEditingController commentEditingController =
      TextEditingController();
  void postComment(String uid, String name, String profilePic) async {
    try {
      String res = await FireStoreMethods().postComment(
          widget.postId, commentEditingController.text, uid, name, profilePic);
      if (res != 'success') {
        if (context.mounted) showSnackBar(res, context);
      }
      setState(() {
        commentEditingController.text = '';
      });
    } catch (err) {
      showSnackBar(err.toString(), context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<userProvider>(context).getUser;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: const Text(
          'comments',
        ),
        centerTitle: false,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('post')
            .doc(widget.postId)
            .collection('comments')
            .snapshots(),
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (ctx, index) => CommentCard(
              snap: snapshot.data!.docs[index],
            ),
          );
        },
      ),
      //text input
      bottomNavigationBar: SafeArea(
        child: Container(
            height: kToolbarHeight,
            margin: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            padding: const EdgeInsets.only(left: 16, right: 8),
            child: Row(
              children: [
                CircleAvatar(
                    backgroundImage: NetworkImage(user.photoURL), radius: 18),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16, right: 8),
                    child: TextField(
                      controller: commentEditingController,
                      decoration: InputDecoration(
                        hintText: "comment as ${user.username}",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () => postComment(
                    user.uid,
                    user.username,
                    user.photoURL,
                  ),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                    child: const Text(
                      'Post',
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
