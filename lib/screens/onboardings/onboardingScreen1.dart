import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project1/utils/colors.dart';
import 'package:project1/utils/images.dart';

import '../../utils/fonts.dart';

class onboardingScreen1 extends StatelessWidget {
  const onboardingScreen1({Key? key}) : super(key: key);

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
              child: Image.asset(obHandCalendar, scale: 1),
            ),
            const SizedBox(
              height: 35,
            ),
            Text(
              'Schedule your pets',
              style: GoogleFonts.quicksand(
                textStyle: AppTextStyle.Title1,
              ),
            ),
            const SizedBox(
              height: 17,
            ),
            Text(
              "You can store all information about your\n pets. Add notes and receive reminder.",
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
