import 'package:flutter/material.dart';
import 'package:rapido/utils/colors.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rapido/widgets/text_field_input.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
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
                Flexible(flex: 2, child: Container()),
                // svg image
                SvgPicture.asset(
                  'assets/ic_instagram.svg',
                  colorFilter: const ColorFilter.mode(primaryColor, BlendMode.srcIn),
                  height: 64,
                ),
                const SizedBox(
                  height: 64,
                ),
                // text fields input for email
                TextFieldInput(
                    textEditingController: _emailController,
                    hintText: 'Enter your email',
                    textInputType: TextInputType.emailAddress),
                const SizedBox(
                  height: 24,
                ),
                // text fields input for password
                TextFieldInput(
                    textEditingController: _passwordController,
                    hintText: 'Enter your password',
                    textInputType: TextInputType.text,
                    isPassword: true),
                const SizedBox(
                  height: 24,
                ),
                // button login
                InkWell(
                  child: Container(
                    width: double.infinity,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: const ShapeDecoration(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(4)),
                        ),
                        color: blueColor),
                    child: const Text('Log in'),
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                Flexible(flex: 2, child: Container()),

                // Transitionning to the sign up page
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: const Text('Don\'t have an account?'),
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: const Text(
                          'Sign up',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            )),
      ),
    );
  }
}
