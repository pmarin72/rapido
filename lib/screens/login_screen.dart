import 'package:flutter/material.dart';
import 'package:rapido/responsive/mobile_screen_layout.dart';
import 'package:rapido/responsive/responsive_layout_screen.dart';
import 'package:rapido/responsive/web_screen_layout.dart';
import 'package:rapido/ressources/auth_methods.dart';
import 'package:rapido/screens/signup_screen.dart';
import 'package:rapido/utils/colors.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rapido/utils/utils.dart';
import 'package:rapido/widgets/text_field_input.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void loginUser() async {
    setState(() {
      _isLoading = true;
    });
    String res = await AuthMethods().loginUser(
      email: _emailController.text,
      password: _passwordController.text,
    );
    if (res == 'success') {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const ResponsiveLayoutScreen(
            mobileScreenLayout: MobileScreenLayout(),
            webScreenLayout: WebScreenLayout(),
          ),
        ),
      );
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
        builder: (context) => const SignupScreen(),
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
                Flexible(flex: 2, child: Container()),
                // svg image
                SvgPicture.asset(
                  'assets/ic_instagram.svg',
                  colorFilter:
                      const ColorFilter.mode(primaryColor, BlendMode.srcIn),
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
                  onTap: loginUser,
                  child: Container(
                    width: double.infinity,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: const ShapeDecoration(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(4)),
                        ),
                        color: blueColor),
                    child: _isLoading
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: primaryColor,
                            ),
                          )
                        : const Text('Log in'),
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
                      onTap: navigateToSignUp,
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
