import 'package:flutter/material.dart';
import 'package:sociagram/screens/login_screen.dart';
import 'package:sociagram/utils/colors.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyAZ-DrLX5l26q8EmnkA7kY7TQeb6dDNb2Q",
          appId: "1:64962634608:web:eb28441ab26b86e30625b5",
          messagingSenderId: "64962634608",
          projectId: "sociagram-13a74",
          storageBucket: "sociagram-13a74.appspo  `t.com"),
    );
  } else {
    await Firebase.initializeApp();
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Sociagram',
        theme: ThemeData.dark()
            .copyWith(scaffoldBackgroundColor: mobileBackgroundColor),
        // home: const ResponsiveLayout(
        //   mobileScreenLayout: mobileScreenLayout(),
        //   webScreenLayout: webscreenLayout(),
        // ),
        home: const LoginScreen());
  }
}
