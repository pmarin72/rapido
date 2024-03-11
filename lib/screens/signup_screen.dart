import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rapido/ressources/auth_methods.dart';
import 'package:rapido/utils/colors.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rapido/utils/utils.dart';
import 'package:rapido/widgets/text_field_input.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  Uint8List? _image;
  bool isLoading = false;
  
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  void selectImage() async {
    Uint8List im = await pickImage(ImageSource.gallery);
    setState(() {
      _image = im;
    });
  }

  void signUpUser() async {
    setState(() {
      isLoading = true;
    });
    String res = await AuthMethods().signUpUser(
      email: _emailController.text,
      password: _passwordController.text,
      username: _usernameController.text,
      bio: _bioController.text,
      file: _image!,
    );
    setState(() {
      isLoading = false;
    });
    if(res != 'success') {
      showSnackBar(res, context);
    } 
  }
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                flex: 2, 
                child: Container()
              ),
              // svg image
              SvgPicture.asset(
                'assets/ic_instagram.svg',
                colorFilter: const ColorFilter.mode(primaryColor, BlendMode.srcIn),
                height: 64,
              ),
              const SizedBox(
                height: 64,
              ),
              // circular widget to accept andf show our selected file
              Stack(
                children: [
                  _image != null 
                  ? CircleAvatar(
                    radius: 64,
                    backgroundImage: MemoryImage(_image!),
                  ) : const CircleAvatar(
                    radius: 64,
                    backgroundImage: NetworkImage('https://www.pngkey.com/png/full/114-1149878_setting-user-avatar-in-specific-size-without-breaking.png'),
                  ),
                  Positioned(
                    bottom: -10,
                    left: 80,
                    child: IconButton(
                      onPressed: selectImage,
                      icon: const Icon(Icons.add_a_photo),
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 64,
              ),
              // text field input for username
              TextFieldInput(
                textEditingController: _usernameController,
                hintText: 'Enter your username',
                textInputType: TextInputType.text
              ),
              const SizedBox(
                height: 24,
              ),
              // text fields input for email
              TextFieldInput(
                textEditingController: _emailController,
                hintText: 'Enter your email',
                textInputType: TextInputType.emailAddress
              ),
              const SizedBox(
                height: 24,
              ),
                // text fields input for password
              TextFieldInput(
                textEditingController: _passwordController,
                hintText: 'Enter your password',
                textInputType: TextInputType.text,
                isPassword: true
              ),
              const SizedBox(
                height: 24,
              ),
              // button login
              InkWell(
                onTap: signUpUser, 
                child: Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: const ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                    ),
                    color: blueColor
                  ),
                  child: isLoading ? const Center(child: CircularProgressIndicator(color: primaryColor)) : const Text('Sign up'),
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
                    child: const Text('Already have an account?'),
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: const Text(
                        'Login',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              )
            ],
          )
        ),
      ),
    );
  }
}
