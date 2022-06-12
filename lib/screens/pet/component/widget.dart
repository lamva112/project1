import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../utils/colors.dart';

Widget InputTextFormField(
    {required String hintText,
    required TextEditingController textEditingController,
    required Size size,
    required double padding}) {
  return Container(
    margin: const EdgeInsets.only(left: 32, right: 32),
    width: size.width,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(4),
      color: AppColors.white,
    ),
    child: TextFormField(
      cursorColor: AppColors.grey1,
      controller: textEditingController,
      keyboardType: TextInputType.emailAddress,
      autofillHints: const [AutofillHints.email],
      // decoration: InputDecoration(
      //   hintText: hintText,
      //   hintStyle: TextStyle(color: AppColors.grey1),
      //   border: InputBorder.none,
      // ),
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.only(left: 8, right: 8),
        hintStyle: GoogleFonts.poppins(
          textStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: AppColors.grey1,
          ),
        ),
        hintText: "Enter your Email",
        filled: true,
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(8.0),
        ),
        errorStyle: const TextStyle(
          color: Colors.transparent,
          fontSize: 0,
          height: 0,
        ),
      ),
    ),
  );
}
