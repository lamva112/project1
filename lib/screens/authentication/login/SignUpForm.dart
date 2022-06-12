import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:project1/resources/sign_up_auth.dart';
import 'package:project1/screens/authentication/login/login.dart';

import '../../../constants/reg_exp.dart';
import '../../../utils/colors.dart';
import '../../../utils/enum_generation.dart';
import '../../../utils/fonts.dart';
import '../../../utils/loading_widget.dart';

import '../components/comomAuthMethod.dart';

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

  final EmailAndPasswordAuth _emailAndPasswordAuth = EmailAndPasswordAuth();
  bool _isLoading = false;

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
            child: Form(
              key: _signUpKey,
              child: SizedBox(
                width: widget.size.width,
                height: widget.defaultLoginSize,
                child: _isLoading
                    ? const LoadingWidget()
                    : Column(
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
                                  if (!emailRegex.hasMatch(inputVal.toString())) {
                                    return 'Email format is not matching';
                                  }
                                  return null;
                                },
                                textEditingController: _email,
                                icon: Icons.email),
                            PasswordTextFormField(
                                hintText: 'Password',
                                sizeiput: sizeinput,
                                validator: (String? inputVal) {
                                  if (inputVal!.length < 6) {
                                    return 'Password must be at least 6 characters';
                                  }
                                  return null;
                                },
                                textEditingController: _pwd,
                                icon: Icons.lock),
                            PasswordTextFormField(
                                hintText: 'Conform Password',
                                sizeiput: sizeinput,
                                validator: (String? inputVal) {
                                  if (inputVal!.length < 6) {
                                    return 'Password must be at least 6 characters';
                                  }
                                  if (_pwd.text != _conformPwd.text) {
                                    return 'Password and Conform Password Not Same Here';
                                  }
                                  return null;
                                },
                                textEditingController: _conformPwd,
                                icon: Icons.lock),
                            signUpAuthButton(context, "Sign Up"),
                          ]),
              ),
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
            padding: const EdgeInsets.only(
              left: 20.0,
              right: 20.0,
              top: 7.0,
              bottom: 7.0,
            ),
            shape: const RoundedRectangleBorder(
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
            if (mounted) {
              setState(() {
                _isLoading = true;
              });
            }
            SystemChannels.textInput.invokeMethod('TextInput.hide');

            final EmailSignUpResults response = await _emailAndPasswordAuth
                .sinUpAuth(email: _email.text, pwd: _pwd.text);

            if (response == EmailSignUpResults.SignUpCompleted) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const LoginScreen(),
                ),
              );
            } else {
              final String msg =
                  response == EmailSignUpResults.EmailAlreadyPresent
                      ? 'Email Already Present'
                      : 'Sign Up Not Completed';
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(msg),
                ),
              );
            }
          } else {
            print('Not Validated');
          }
          if (mounted) {
            setState(() {
              _isLoading = false;
            });
          }
        },
      ),
    );
  }
}
