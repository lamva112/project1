import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:project1/screens/pet/petProfile.dart';
import 'package:project1/utils/colors.dart';
import 'package:project1/utils/enum_generation.dart';

import '../../../constants/reg_exp.dart';
import '../../../resources/cloud_data_management.dart';
import '../../../resources/sign_up_auth.dart';
import '../../../utils/fonts.dart';
import '../../../utils/loading_widget.dart';

import '../../mainscreen/mainscreen.dart';
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
  final CloudStoreDataManagement _cloudStoreDataManagement =
      CloudStoreDataManagement();
  final EmailAndPasswordAuth _emailAndPasswordAuth = EmailAndPasswordAuth();
  bool _isLoading = false;

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
              child: _isLoading
                  ? LoadingWidget()
                  : Column(
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
            if (mounted) {
              setState(() {
                this._isLoading = true;
              });
            }

            final EmailSignInResults emailSignInResults =
                await _emailAndPasswordAuth.signInWithEmailAndPassword(
                    email: this._email.text, pwd: this._pwd.text);

            String msg = '';
            if (emailSignInResults == EmailSignInResults.SignInCompleted) {
              final bool _dataPresentResponse =
                  await _cloudStoreDataManagement.userRecordPresentOrNot(
                      uid: FirebaseAuth.instance.currentUser!.uid.toString());

              _dataPresentResponse
                  ? Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PetProfileScreen(),
                      ),
                      (route) => false)
                  : Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (_) => EditProfileScreen(),
                      ),
                      (route) => false);
            } else if (emailSignInResults ==
                EmailSignInResults.EmailNotVerified) {
              msg =
                  'Email not Verified.\nPlease Verify your email and then Log In';
            } else if (emailSignInResults ==
                EmailSignInResults.EmailOrPasswordInvalid)
              msg = 'Email And Password Invalid';
            else
              msg = 'Sign In Not Completed';

            if (msg != '')
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(msg)));
          } else {
            print('Not Validated');
          }
          if (mounted) {
            setState(() {
              this._isLoading = false;
            });
          }
        },
      ),
    );
  }
}
