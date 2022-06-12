import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'colors.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          SpinKitSpinningLines(
            color: AppColors.red,
            size: 50.0,
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            'Loading...',
            style: TextStyle(
              fontFamily: 'SFProText',
              fontSize: 16,
              color: AppColors.white,
              fontWeight: FontWeight.w400,
            ),
          )
        ],
      ),
    );
  }
}
