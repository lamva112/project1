import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project1/utils/colors.dart';
import 'package:project1/utils/images.dart';

import '../../utils/fonts.dart';

class onboardingScreen3 extends StatelessWidget {
  const onboardingScreen3({Key? key}) : super(key: key);

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
              height: 82,
            ),
            Container(
              alignment: Alignment.topCenter,
              child: Image.asset(obDocumentFile, scale: 1),
            ),
            const SizedBox(
              height: 35,
            ),
            Text(
              'Manage all your pets',
              style: GoogleFonts.quicksand(
                textStyle: AppTextStyle.Title1,
              ),
            ),
            const SizedBox(
              height: 17,
            ),
            Text(
              "You will be able to control the care of all the\n pets that you have or you can find Spa and\n\t\t\t\t\t\t\t\t\t\t\t\t\t Clinic for them imadiately.",
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
