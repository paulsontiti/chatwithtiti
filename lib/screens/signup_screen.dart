import 'dart:typed_data';

import 'package:chat_app/firebase/auth/auth_methods.dart';
import 'package:chat_app/responsive/mobile_screen_layout.dart';
import 'package:chat_app/responsive/responsive_layout_screen.dart';
import 'package:chat_app/responsive/web_screen_layout.dart';
import 'package:chat_app/screens/login_screen.dart';
import 'package:chat_app/utils/colors.dart';
import 'package:chat_app/utils/snackbar.dart';
import 'package:chat_app/utils/utils.dart';
import 'package:chat_app/widgets/text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _SignUpScreenState();
  }
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _emailEditingController = TextEditingController();
  final TextEditingController _passwordEditingController =
      TextEditingController();
  final TextEditingController _bioEditingController = TextEditingController();
  final TextEditingController _usernameEditingController =
      TextEditingController();
  Uint8List? _image;
  bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _emailEditingController.dispose();
    _passwordEditingController.dispose();
    _bioEditingController.dispose();
    _usernameEditingController.dispose();
  }

  void selectImage(dynamic context) async {
    Uint8List img = await pickImage(ImageSource.gallery, context);
    setState(() {
      _image = img;
    });
  }

  void navigateToLoginpScreen() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const LoginScreen()));
  }

  void signUpUser(dynamic context) async {
    setState(() {
      _isLoading = true;
    });
    if (_image == null) {
      showSnackbar("Please select your profile picture", context);
      setState(() {
        _isLoading = false;
      });
    } else {
      String res = await AuthMethods().signUpUser(
          email: _emailEditingController.text,
          password: _passwordEditingController.text,
          username: _usernameEditingController.text,
          bio: _bioEditingController.text,
          dp: _image!);
      if (res == 'success') {
        // ignore: use_build_context_synchronously
        showSnackbar("Your account was created successfully", context);
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => const ResponsiveLayout(
                webScreenLayout: WebScreenLayout(),
                mobileScreenLayout: MobileScreenLayout())));
      } else {
        // ignore: use_build_context_synchronously
        showSnackbar(res, context);
      }
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
        data: ThemeData.dark().copyWith(scaffoldBackgroundColor: mobileBgColor),
        child: Scaffold(
            body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(flex: 2, child: Container()),
              Column(
                children: [
                  SvgPicture.asset(
                    "assets/images/logo.svg",
                    colorFilter:
                        const ColorFilter.mode(primaryColor, BlendMode.srcIn),
                    height: 64,
                  ),
                  const Text(
                    "BEATIFULS",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                  )
                ],
              ),
              const SizedBox(
                height: 24,
              ),
              Stack(
                children: [
                  _image == null
                      ? const CircleAvatar(
                          radius: 64,
                          backgroundImage: AssetImage("assets/images/dp.png"),
                        )
                      : CircleAvatar(
                          radius: 64,
                          backgroundImage: MemoryImage(_image!),
                        ),
                  Positioned(
                      bottom: -10,
                      left: 80,
                      child: IconButton(
                          onPressed: () {
                            selectImage(context);
                          },
                          icon: const Icon(
                            Icons.add_a_photo,
                            color: Colors.white,
                          )))
                ],
              ),
              const SizedBox(
                height: 12,
              ),
              TextFieldInput(
                  hintText: "Enter your email",
                  textEditingController: _emailEditingController,
                  textInputType: TextInputType.emailAddress),
              const SizedBox(
                height: 12,
              ),
              TextFieldInput(
                hintText: "Enter your username",
                textEditingController: _usernameEditingController,
                textInputType: TextInputType.text,
              ),
              const SizedBox(
                height: 12,
              ),
              TextFieldInput(
                hintText: "Enter your password",
                textEditingController: _passwordEditingController,
                textInputType: TextInputType.text,
                isPassword: true,
              ),
              const SizedBox(
                height: 24,
              ),
              TextFieldInput(
                  hintText: "Enter your bio",
                  textEditingController: _bioEditingController,
                  textInputType: TextInputType.emailAddress),
              const SizedBox(
                height: 24,
              ),
              InkWell(
                onTap: () {
                  signUpUser(context);
                },
                child: Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: const ShapeDecoration(
                      color: blueColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20)))),
                  child: _isLoading
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: primaryColor,
                          ),
                        )
                      : const Text("Sign up"),
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: const Text("Already has an account?"),
                  ),
                  GestureDetector(
                    onTap: navigateToLoginpScreen,
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        "Log in",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  )
                ],
              ),
              Flexible(flex: 2, child: Container()),
            ],
          ),
        )));
  }
}
