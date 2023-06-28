import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sociagram/Resources/auth_methods.dart';

import 'package:sociagram/utils/colors.dart';
import 'package:sociagram/Widgets/text_input_field.dart';
import 'package:sociagram/screens/signup_screen.dart';
import 'package:sociagram/utils/utils.dart';
import 'package:sociagram/responsive/webscreen_layout.dart';
import 'package:sociagram/responsive/mobilescreen_layout.dart';

import '../responsive/responsive_layoutscreen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordContorller = TextEditingController();
  bool _isLoading = false;
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _emailController.dispose();
    _passwordContorller.dispose();
  }

  void LoginUser() async {
    setState(() {
      _isLoading = true;
    });

    String res = await AuthMethods().loginUser(
        email: _emailController.text, password: _passwordContorller.text);

    if (res == "success") {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const ResponsiveLayout(
            mobileScreenLayout: mobileScreenLayout(),
            webScreenLayout: webscreenLayout(),
          ),
        ),
      );
      // Navigator.of(context).pushReplacement(
      //     MaterialPageRoute(builder: (context) => const HomeScreen()));
    } else {
      showSnackBar(res, context);
    }
    setState(() {
      _isLoading = false;
    });
  }

  void navigateToSignUp() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const SignUpScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            width: double.infinity,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Flexible(child: Container(), flex: 1),
                  SvgPicture.asset(
                    'assets/ic_instagram.svg',
                    height: 64,
                    color: primaryColor,
                  ),
                  const SizedBox(height: 64),
                  TextFileInput(
                    hintText: 'Enter your Email',
                    textInputType: TextInputType.emailAddress,
                    textEditingController: _emailController,
                  ),
                  const SizedBox(height: 24),
                  TextFileInput(
                      hintText: 'Enter your password',
                      textInputType: TextInputType.text,
                      textEditingController: _passwordContorller,
                      isPass: true),
                  const SizedBox(height: 24),
                  InkWell(
                    onTap: LoginUser,
                    child: Container(
                      child: _isLoading
                          ? const Center(
                              child: CircularProgressIndicator(
                                  color: primaryColor),
                            )
                          : const Text('Log in'),
                      width: double.infinity,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: const ShapeDecoration(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(4),
                            ),
                          ),
                          color: blueColor),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Flexible(child: Container(), flex: 2),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        child: const Text("Don't have an account?"),
                        padding: const EdgeInsets.symmetric(
                          vertical: 8,
                        ),
                      ),
                      GestureDetector(
                        onTap: navigateToSignUp,
                        child: Container(
                          child: const Text("Sign up",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          padding: const EdgeInsets.symmetric(
                            vertical: 8,
                          ),
                        ),
                      ),
                    ],
                  )
                ])),
      ),
    );
  }
}
