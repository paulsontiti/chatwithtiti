import 'package:chat_app/utils/colors.dart';
import 'package:chat_app/widgets/text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _LoginScreenState();
  }
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailEditingController = TextEditingController();
  final TextEditingController _passwordEditingController =
      TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _emailEditingController.dispose();
    _passwordEditingController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Container(
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
                "Chat With Titi",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
              )
            ],
          ),
          const SizedBox(
            height: 64,
          ),
          TextFieldInput(
              hintText: "Enter your email",
              textEditingController: _emailEditingController,
              textInputType: TextInputType.emailAddress),
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
          InkWell(
            child: Container(
              width: double.infinity,
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: const ShapeDecoration(
                  color: blueColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)))),
              child: const Text("Log in"),
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
                child: const Text("Don't have an account?"),
              ),
              GestureDetector(
                onTap: null,
                child: const Text(
                  "Sign Up",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            ],
          ),
          Flexible(flex: 2, child: Container()),
        ],
      ),
    ));
  }
}
