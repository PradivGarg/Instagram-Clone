import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sociagram/utils/colors.dart';

class mobileScreenLayout extends StatefulWidget {
  const mobileScreenLayout({Key? key}) : super(key: key);
  @override
  State<mobileScreenLayout> createState() => _MobileScreenLayoutState();
}

class _MobileScreenLayoutState extends State<mobileScreenLayout> {
  // String username = '';
  // @override
  // void initState() {
  //   super.initState();
  //   getUsername();
  // }

  // void getUsername() async {
  //   DocumentSnapshot snap = await FirebaseFirestore.instance
  //       .collection('users')
  //       .doc(FirebaseAuth.instance.currentUser!.uid)
  //       .get();
  //   setState(() {
  //     username = (snap.data() as Map<String, dynamic>)['username'];
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('This is mobile'),
      ),
      bottomNavigationBar: CupertinoTabBar(
        backgroundColor: mobileBackgroundColor,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home), label: '', backgroundColor: primaryColor),
          BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: '',
              backgroundColor: primaryColor),
          BottomNavigationBarItem(
              icon: Icon(Icons.add_circle),
              label: '',
              backgroundColor: primaryColor),
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite),
              label: '',
              backgroundColor: primaryColor),
          BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: '',
              backgroundColor: primaryColor)
        ],
      ),
    );
  }
}
