import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project1/utils/colors.dart';
import 'package:project1/utils/images.dart';

import '../../utils/fonts.dart';

class onboardingScreen2 extends StatelessWidget {
  const onboardingScreen2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: SystemUiOverlayStyle(
          statusBarBrightness: Brightness.dark,
          statusBarIconBrightness: Brightness.light,
          statusBarColor: Colors.transparent),
      child: Scaffold(
        body: Container(
          color: AppColors.white,
          child: Column(children: [
            SizedBox(
              height: 82,
            ),
            Container(
              alignment: Alignment.topCenter,
              child: Image.asset(obTargetDynamic, scale: 1),
            ),
            SizedBox(
              height: 35,
            ),
            Text(
              "Track's your pets",
              style: GoogleFonts.quicksand(
                textStyle: AppTextStyle.Title1,
              ),
            ),
            SizedBox(
              height: 17,
            ),
            Text(
              "You can track your pets' by using a GPS-\ntracker and don’t worry about losing them.",
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
