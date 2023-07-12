import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sociagram/models/user.dart';

class PostCard extends StatefulWidget {
  final snap;
  const PostCard({Key? key, required this.snap}) : super(key: key);
  @override
  State<PostCard> createState() => _postCardState();
}

class _postCardState extends State<PostCard> {}
