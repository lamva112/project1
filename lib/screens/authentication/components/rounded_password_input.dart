import 'package:flutter/material.dart';

import '../../../utils/colors.dart';
import 'input_container.dart';

class RoundedPasswordInput extends StatelessWidget {
  const RoundedPasswordInput({
    Key? key,
    required this.hint,
  }) : super(key: key);

  final String hint;

  @override
  Widget build(BuildContext context) {
    return InputContainer(
      child: TextField(
        cursorColor: AppColors.red,
        obscureText: true,
        decoration: InputDecoration(
          icon: Icon(
            Icons.lock,
            color: AppColors.blue,
          ),
          hintText: hint,
          border: InputBorder.none,
        ),
      ),
    );
  }
}
