import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sociagram/Widgets/text_input_field.dart';
import 'package:sociagram/utils/colors.dart';
import 'package:sociagram/Resources/auth_methods.dart';


class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordContorller = TextEditingController();
  final TextEditingController _bioContorller = TextEditingController();
  final TextEditingController _usernameContorller = TextEditingController();
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _emailController.dispose();
    _passwordContorller.dispose();
    _bioContorller.dispose();
    _usernameContorller.dispose();
  }

  void SelectImage()

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
                  //circular widget to accept to show our selected file
                  Stack(children: [
                    const CircleAvatar(
                      radius: 64,
                      backgroundImage: NetworkImage(
                          'https://images.unsplash.com/photo-1687488896809-6547211d9258?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=387&q=80'),
                    ),
                    Positioned(
                        bottom: -10,
                        left: 80,
                        child: IconButton(
                          onPressed: SelectImage,
                          icon: const Icon(
                            Icons.add_a_photo,
                          ),
                        ))
                  ]),
                  const SizedBox(height: 24),
                  //username text field
                  TextFileInput(
                    hintText: 'Enter your username',
                    textInputType: TextInputType.text,
                    textEditingController: _usernameContorller,
                  ),
                  const SizedBox(height: 24),
                  //email field
                  TextFileInput(
                    hintText: 'Enter your Email',
                    textInputType: TextInputType.emailAddress,
                    textEditingController: _emailController,
                  ),
                  const SizedBox(height: 24),
                  //password field
                  TextFileInput(
                      hintText: 'Enter your password',
                      textInputType: TextInputType.text,
                      textEditingController: _passwordContorller,
                      isPass: true),
                  // bio field
                  const SizedBox(height: 24),
                  //username text field
                  TextFileInput(
                    hintText: 'enter your bio',
                    textInputType: TextInputType.text,
                    textEditingController: _bioContorller,
                  ),
                  const SizedBox(height: 24),
                  //button for sign-up
                  InkWell(
                    onTap: () async {
                      String res = await AuthMethods().SignUpUser(
                        email: _emailController.text,
                        password: _passwordContorller.text,
                        username: _usernameContorller.text,
                        bio: _bioContorller.text,
                        file: 
                      );
                      print(res);
                    },
                    child: Container(
                      child: const Text('sign up'),
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
                        child: const Text("Already have an account?"),
                        padding: const EdgeInsets.symmetric(
                          vertical: 8,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: Container(
                          child: const Text("login",
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
