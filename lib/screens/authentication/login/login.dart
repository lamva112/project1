import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:project1/screens/authentication/components/rounded_password_input.dart';
import 'package:project1/utils/colors.dart';

import '../components/rounded_button.dart';
import '../components/rounded_input.dart';
import 'LoginForm.dart';
import 'SignUpForm.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  bool isLogin = true;
  late Animation<double> containerSize;
  late AnimationController animationController;
  late Duration animationDuration = Duration(milliseconds: 270);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);

    animationController =
        AnimationController(vsync: this, duration: animationDuration);
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double viewInset = MediaQuery.of(context).viewInsets.bottom;
    double defaultLoginSize = size.height - (size.height * 0.1);
    double defaultRegesterSize = size.height - (size.height * 0.1);

    containerSize =
        Tween<double>(begin: size.height * 0.1, end: defaultRegesterSize)
            .animate(
      CurvedAnimation(parent: animationController, curve: Curves.linear),
    );
    return Scaffold(
      body: Stack(children: [
        LoginForm(
            isLogin: isLogin,
            animationDuration: animationDuration,
            size: size,
            defaultLoginSize: defaultLoginSize),
        AnimatedBuilder(
          animation: animationController,
          builder: (context, child) {
            if (viewInset == 0 && isLogin) {
              return buildRegisterContainer();
            } else if (!isLogin) {
              return buildRegisterContainer();
            }
            return Container();
          },
        ),
        SignUpForm(
            isLogin: isLogin,
            animationDuration: animationDuration,
            size: size,
            defaultLoginSize: defaultLoginSize),
        AnimatedOpacity(
          opacity: isLogin ? 0.0 : 1.0,
          duration: animationDuration,
          child: Align(
            alignment: Alignment.topCenter,
            child: Container(
              width: size.width,
              height: size.height * 0.1,
              alignment: Alignment.bottomCenter,
              child: IconButton(
                icon: Icon(
                  Icons.close,
                ),
                onPressed: () {
                  animationController.reverse();
                  setState(() {
                    isLogin = !isLogin;
                  });
                },
                color: AppColors.blue,
              ),
            ),
          ),
        ),
      ]),
    );
  }

  Widget buildRegisterContainer() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: double.infinity,
        height: containerSize.value,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(100),
            topRight: Radius.circular(100),
          ),
          color: AppColors.grey4,
        ),
        alignment: Alignment.center,
        child: GestureDetector(
          onTap: () {
            setState(() {
              animationController.forward();
              isLogin = !isLogin;
            });
          },
          child: isLogin
              ? Text(
                  "Don't have an account? Sign up",
                  style: GoogleFonts.quicksand(
                    textStyle: TextStyle(
                      color: AppColors.blue,
                      fontSize: 18,
                    ),
                  ),
                )
              : null,
        ),
      ),
    );
  }
}
