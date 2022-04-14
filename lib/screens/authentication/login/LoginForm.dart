import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:project1/utils/colors.dart';

import '../../../utils/fonts.dart';
import '../../constants/reg_exp.dart';
import '../../profile/edit_profile_screen.dart';
import '../components/comomAuthMethod.dart';
import '../components/rounded_button.dart';
import '../components/rounded_input.dart';
import '../components/rounded_password_input.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({
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
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final GlobalKey<FormState> _logInKey = GlobalKey<FormState>();

  final TextEditingController _email = TextEditingController();
  final TextEditingController _pwd = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size sizeinput = MediaQuery.of(context).size;
    return AnimatedOpacity(
      opacity: widget.isLogin ? 1.0 : 0.0,
      duration: widget.animationDuration * 4,
      child: Align(
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Form(
            key: _logInKey,
            child: Container(
              width: widget.size.width,
              height: widget.defaultLoginSize,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 300,
                      height: 200,
                      alignment: Alignment.topCenter,
                      child: Lottie.network(
                          'https://assets6.lottiefiles.com/packages/lf20_z9ed2jna.json'),
                    ),
                    Text(
                      "Login or Sign up",
                      style: GoogleFonts.quicksand(
                        textStyle: AppTextStyle.Title2,
                      ),
                    ),
                    Text(
                      "Login so you can care your pets easily.",
                      style: GoogleFonts.quicksand(
                        textStyle: AppTextStyle.Subheadline1,
                      ),
                    ),
                    SizedBox(
                      height: 50,
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
                    logInAuthButton(context, 'Sign In'),
                    socialMediaInterationButtons(),
                  ]),
            ),
          ),
        ),
      ),
    );
  }

  Widget logInAuthButton(BuildContext context, String buttonName) {
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
          if (this._logInKey.currentState!.validate()) {
            print('Validated');
            SystemChannels.textInput.invokeMethod('TextInput.hide');
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => EditProfileScreen()),
            );
          } else {
            print('Not Validated');
          }
        },
      ),
    );
  }
}
