import 'package:flutter/material.dart';

import '../../utils/colors.dart';

Widget TextFieldInput(
    {required String? Function(String?)? validator,
    required TextEditingController textEditingController,
    required Size size}) {
  return Container(
    margin: const EdgeInsets.only(left: 24, right: 24),
    width: size.width,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(7),
      color: AppColors.grey3.withAlpha(50),
    ),
    child: Padding(
      padding: const EdgeInsets.only(left: 16),
      child: TextFormField(
        validator: validator,
        cursorColor: AppColors.red,
        controller: textEditingController,
        decoration: const InputDecoration(
          hintStyle: TextStyle(color: AppColors.black),
          border: InputBorder.none,
        ),
      ),
    ),
  );
}
