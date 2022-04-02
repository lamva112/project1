import 'package:flutter/material.dart';
import 'package:liquid_swipe/liquid_swipe.dart';
import 'package:project1/screens/onboardings/welcomescreen.dart';

import 'package:project1/utils/colors.dart';

import '../authentication/login/login.dart';
import 'onboardingScreen1.dart';
import 'onboardingScreen2.dart';
import 'onboardingScreen3.dart';

import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class onboardingWrapper extends StatefulWidget {
  onboardingWrapper({Key? key}) : super(key: key);

  @override
  State<onboardingWrapper> createState() => _onboardingWrapperState();
}

class _onboardingWrapperState extends State<onboardingWrapper> {
  final controller = LiquidController();
  @override
  Widget build(BuildContext context) => Scaffold(
        body: Stack(
          children: [
            LiquidSwipe(
              liquidController: controller,
              waveType: WaveType.liquidReveal,
              enableSideReveal: true,
              onPageChangeCallback: (index) {
                setState(() {});
              },
              slideIconWidget: const Icon(
                Icons.arrow_back_ios,
                color: AppColors.black,
              ),
              pages: [
                wellcomeScreen(),
                onboardingScreen1(),
                onboardingScreen2(),
                onboardingScreen3(),
              ],
            ),
            Positioned(
              bottom: 0,
              left: 16,
              right: 32,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                      );
                    },
                    child: const Text('SKIP'),
                  ),
                  AnimatedSmoothIndicator(
                    activeIndex: controller.currentPage,
                    count: 4,
                    effect: const WormEffect(
                      spacing: 16,
                      dotColor: AppColors.blue,
                      activeDotColor: AppColors.black,
                    ),
                    onDotClicked: (index) {
                      controller.animateToPage(page: index);
                    },
                  ),
                  TextButton(
                    onPressed: () {
                      final page = controller.currentPage + 1;

                      page == 4
                          ? Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginScreen()),
                            )
                          : controller.animateToPage(
                              page: page > 4 ? 0 : page, duration: 400);
                    },
                    child: const Text('NEXT'),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
}
