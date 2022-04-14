import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

import '../../../utils/colors.dart';
import '../../../utils/fonts.dart';
import '../../constants/reg_exp.dart';
import '../components/comomAuthMethod.dart';
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
  final GlobalKey<FormState> _signUpKey = GlobalKey<FormState>();

  final TextEditingController _email = TextEditingController();
  final TextEditingController _pwd = TextEditingController();
  final TextEditingController _conformPwd = TextEditingController();
  @override
  Widget build(BuildContext context) {
    Size sizeinput = MediaQuery.of(context).size;
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
                    EmailTextFormField(
                        hintText: 'Email',
                        sizeiput: sizeinput,
                        validator: (String? inputVal) {
                          if (!emailRegex.hasMatch(inputVal.toString()))
                            return 'Email format is not matching';
                          return null;
                        },
                        textEditingController: this._email,
                        icon: Icons.email),
                    PasswordTextFormField(
                        hintText: 'Password',
                        sizeiput: sizeinput,
                        validator: (String? inputVal) {
                          if (inputVal!.length < 6)
                            return 'Password must be at least 6 characters';
                          return null;
                        },
                        textEditingController: this._pwd,
                        icon: Icons.lock),
                    PasswordTextFormField(
                        hintText: 'Conform Password',
                        sizeiput: sizeinput,
                        validator: (String? inputVal) {
                          if (inputVal!.length < 6)
                            return 'Password must be at least 6 characters';
                          if (this._pwd.text != this._conformPwd.text)
                            return 'Password and Conform Password Not Same Here';
                          return null;
                        },
                        textEditingController: this._conformPwd,
                        icon: Icons.lock),
                    signUpAuthButton(context, "Sign Up"),
                  ]),
            ),
          ),
        ),
      ),
    );
  }

  Widget signUpAuthButton(BuildContext context, String buttonName) {
    return Padding(
      padding: const EdgeInsets.only(left: 50.0, right: 50.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            minimumSize: Size(MediaQuery.of(context).size.width - 10, 40.0),
            elevation: 5.0,
            primary: AppColors.blue,
            padding: EdgeInsets.only(
              left: 20.0,
              right: 20.0,
              top: 7.0,
              bottom: 7.0,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
            )),
        child: Text(
          buttonName,
          style: GoogleFonts.quicksand(
            textStyle: AppTextStyle.Button1,
          ),
        ),
        onPressed: () async {
          if (_signUpKey.currentState!.validate()) {
            print('Validated');
          } else {
            print('Not Validated');
          }
        },
      ),
    );
  }
}
