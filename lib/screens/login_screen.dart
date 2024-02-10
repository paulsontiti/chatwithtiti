import 'package:chat_app/firebase/auth/auth_methods.dart';
import 'package:chat_app/responsive/mobile_screen_layout.dart';
import 'package:chat_app/responsive/responsive_layout_screen.dart';
import 'package:chat_app/responsive/web_screen_layout.dart';
import 'package:chat_app/screens/signup_screen.dart';
import 'package:chat_app/utils/colors.dart';
import 'package:chat_app/utils/global.dart';
import 'package:chat_app/utils/snackbar.dart';
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

  bool _isLoading = false;

  void loginUser(dynamic context) async {
    setState(() {
      _isLoading = true;
    });

    String res = await AuthMethods().loginUser(
        email: _emailEditingController.text,
        password: _passwordEditingController.text);
    if (res == 'success') {
      // ignore: use_build_context_synchronously
      showSnackbar("Login was successful", context);
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

  void navigateToSignUpScreen() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const SignUpScreen()));
  }

  @override
  void dispose() {
    super.dispose();
    _emailEditingController.dispose();
    _passwordEditingController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
        data: ThemeData.dark().copyWith(scaffoldBackgroundColor: mobileBgColor),
        child: Scaffold(
          body: Container(
              padding: MediaQuery.of(context).size.width > sm
                  ? EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width / 6)
                  : const EdgeInsets.symmetric(horizontal: 32),
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
                        colorFilter: const ColorFilter.mode(
                            primaryColor, BlendMode.srcIn),
                        height: 64,
                      ),
                      const Text(
                        "BEAUTIFULS",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 24),
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
                    onTap: () {
                      loginUser(context);
                    },
                    child: Container(
                      width: double.infinity,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: const ShapeDecoration(
                          color: blueColor,
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)))),
                      child: _isLoading
                          ? const Center(
                              child: CircularProgressIndicator(),
                            )
                          : const Text("Log in"),
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: const Text("Don't have an account?"),
                      ),
                      GestureDetector(
                        onTap: navigateToSignUpScreen,
                        child: const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 4),
                          child: Text(
                            "Sign Up",
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
              )),
        ));
  }
}
