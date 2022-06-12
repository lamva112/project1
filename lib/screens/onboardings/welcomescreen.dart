import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project1/utils/colors.dart';
import 'package:project1/utils/fonts.dart';
import 'package:lottie/lottie.dart';

class wellcomeScreen extends StatelessWidget {
  const wellcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: const SystemUiOverlayStyle(
          statusBarBrightness: Brightness.dark,
          statusBarIconBrightness: Brightness.light,
          statusBarColor: Colors.transparent),
      child: Scaffold(
        body: Container(
          color: AppColors.white,
          child: Column(children: [
            const SizedBox(
              height: 62,
            ),
            Container(
              alignment: Alignment.topCenter,
              child: Lottie.network(
                  'https://assets10.lottiefiles.com/packages/lf20_syqnfe7c.json'),
            ),
            const SizedBox(
              height: 35,
            ),
            Text(
              'Wellcome to petcare',
              style: GoogleFonts.quicksand(
                textStyle: AppTextStyle.Title1,
              ),
            ),
            const SizedBox(
              height: 17,
            ),
            Text(
              "it's time you connected with your pet",
              style: GoogleFonts.quicksand(
                textStyle: AppTextStyle.Body1,
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
