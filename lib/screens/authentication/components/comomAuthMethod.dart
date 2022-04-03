import 'package:flutter/material.dart';
import 'package:project1/utils/colors.dart';

Widget EmailTextFormField(
    {required String hintText,
    required String? Function(String?)? validator,
    required TextEditingController textEditingController,
    required IconData icon,
    required Size sizeiput}) {
  return Container(
    margin: EdgeInsets.symmetric(vertical: 10),
    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
    width: sizeiput.width,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(30),
      color: AppColors.grey4.withAlpha(50),
    ),
    child: TextFormField(
      validator: validator,
      cursorColor: AppColors.red,
      controller: textEditingController,
      decoration: InputDecoration(
        icon: Icon(
          icon,
          color: AppColors.blue,
        ),
        hintText: hintText,
        hintStyle: TextStyle(color: AppColors.black),
        border: InputBorder.none,
      ),
    ),
  );
}

Widget PasswordTextFormField(
    {required String hintText,
    required String? Function(String?)? validator,
    required TextEditingController textEditingController,
    required IconData icon,
    required Size sizeiput}) {
  return Container(
    margin: EdgeInsets.symmetric(vertical: 10),
    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
    width: sizeiput.width,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(30),
      color: AppColors.grey4.withAlpha(50),
    ),
    child: TextFormField(
      validator: validator,
      cursorColor: AppColors.red,
      obscureText: true,
      controller: textEditingController,
      decoration: InputDecoration(
        icon: Icon(
          icon,
          color: AppColors.blue,
        ),
        hintText: hintText,
        hintStyle: TextStyle(color: AppColors.black),
        border: InputBorder.none,
      ),
    ),
  );
}

Widget socialMediaInterationButtons() {
  return Container(
    width: double.maxFinite,
    padding: EdgeInsets.all(30),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () async {},
          child: Image.asset(
            'assets/images/google.png',
            width: 70.0,
            height: 70.0,
          ),
        ),
        SizedBox(
          width: 60,
        ),
        GestureDetector(
          onTap: () async {
            print('Google Pressed');
          },
          child: Image.asset(
            'assets/images/fbook.png',
            width: 70.0,
            height: 70.0,
          ),
        ),
      ],
    ),
  );
}
