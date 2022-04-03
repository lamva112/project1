import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

import '../../../utils/fonts.dart';
import '../components/rounded_button.dart';
import '../components/rounded_input.dart';
import '../components/rounded_password_input.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({
    Key? key,
    required this.isLogin,
    required this.animationDuration,
    required this.size,
    required this.defaultLoginSize,
  }) : super(key: key);

  final bool isLogin;
  final Duration animationDuration;
  final Size size;
  final double defaultLoginSize;

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: widget.isLogin ? 0.0 : 1.0,
      duration: widget.animationDuration * 5,
      child: Visibility(
        visible: !widget.isLogin,
        child: Align(
          alignment: Alignment.center,
          child: SingleChildScrollView(
            child: Container(
              width: widget.size.width,
              height: widget.defaultLoginSize,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Welcome to Petcare",
                      style: GoogleFonts.quicksand(
                        textStyle: AppTextStyle.Title2,
                      ),
                    ),
                    Container(
                      width: 300,
                      height: 250,
                      alignment: Alignment.topCenter,
                      child: Lottie.network(
                          'https://assets8.lottiefiles.com/private_files/lf30_emulvclw.json'),
                    ),
                    RoundedInput(
                      icon: Icons.email,
                      hint: 'Email',
                    ),
                    RoundedInput(
                      icon: Icons.face_rounded,
                      hint: 'Name',
                    ),
                    RoundedPasswordInput(hint: 'Password'),
                    RoundedButton(
                      title: 'SIGN UP',
                    ),
                  ]),
            ),
          ),
        ),
      ),
    );
  }
}
