import 'package:flutter/material.dart';
import 'package:project1/utils/colors.dart';

import 'input_container.dart';

class RoundedInput extends StatelessWidget {
  const RoundedInput({
    Key? key,
    required this.icon,
    required this.hint,
  }) : super(key: key);

  final IconData icon;
  final String hint;

  @override
  Widget build(BuildContext context) {
    return InputContainer(
      child: TextField(
        cursorColor: AppColors.red,
        decoration: InputDecoration(
          icon: Icon(
            icon,
            color: AppColors.blue,
          ),
          hintText: 'Username',
          border: InputBorder.none,
        ),
      ),
    );
  }
}
