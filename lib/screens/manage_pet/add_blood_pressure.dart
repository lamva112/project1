import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project1/resources/cloud_data_management.dart';
import 'package:project1/screens/manage_pet/record_infomation.dart';
import 'package:project1/screens/profile/widget.dart';
import 'package:project1/utils/colors.dart';
import 'package:project1/utils/fonts.dart';
import 'package:project1/utils/loading_widget.dart';

class AddBloodPressure extends StatefulWidget {
  AddBloodPressure({Key? key}) : super(key: key);

  @override
  State<AddBloodPressure> createState() => _AddBloodPressureState();
}

class _AddBloodPressureState extends State<AddBloodPressure> {
  final GlobalKey<FormState> _medicalKey = GlobalKey<FormState>();
  final TextEditingController _b = TextEditingController();
  final TextEditingController _db = TextEditingController();
  final TextEditingController _h = TextEditingController();
  bool _isLoading = false;
  final CloudStoreDataManagement _cloudStoreDataManagement =
      CloudStoreDataManagement();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _b.dispose();
    _db.dispose();
    _h.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppColors.grey6,
      body: Form(
        key: _medicalKey,
        child: _isLoading
            ? const Center(child: LoadingWidget())
            : Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 51,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(
                          width: 16,
                        ),
                        SvgPicture.asset(
                          'assets/images/Vector.svg',
                          height: 24,
                        ),
                        const SizedBox(
                          width: 65,
                        ),
                        Text(
                          "blood pressure",
                          style: GoogleFonts.quicksand(
                            textStyle: AppTextStyle.Title2,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 38,
                    ),
                    Row(
                      children: [
                        const SizedBox(
                          width: 24,
                        ),
                        Text(
                          "blood pressure  ",
                          style: GoogleFonts.quicksand(
                            textStyle: AppTextStyle.Body3,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    TextFieldInput(
                      validator: (String? inputVal) {
                        if (inputVal!.length < 1) {
                          return 'blood pressure must be at least 1 characters';
                        }
                        return null;
                      },
                      size: size,
                      textEditingController: _b,
                    ),
                    const SizedBox(
                      height: 32,
                    ),
                    Row(
                      children: [
                        const SizedBox(
                          width: 24,
                        ),
                        Text(
                          "diastolic blood pressure  ",
                          style: GoogleFonts.quicksand(
                            textStyle: AppTextStyle.Body3,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    TextFieldInput(
                      validator: (String? inputVal) {
                        if (inputVal!.length < 1) {
                          return 'diastolic blood pressure must be at least 1 characters';
                        }
                        return null;
                      },
                      size: size,
                      textEditingController: _db,
                    ),
                    const SizedBox(
                      height: 32,
                    ),
                    Row(
                      children: [
                        const SizedBox(
                          width: 24,
                        ),
                        Text(
                          "heartbeat  ",
                          style: GoogleFonts.quicksand(
                            textStyle: AppTextStyle.Body3,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    TextFieldInput(
                      validator: (String? inputVal) {
                        if (inputVal!.length < 1) {
                          return 'heartbeat must be at least 1 characters';
                        }
                        return null;
                      },
                      size: size,
                      textEditingController: _h,
                    ),
                  ],
                ),
              ),
      ),
      bottomSheet: SaveButton(context, 'save'),
    );
  }

  Widget SaveButton(BuildContext context, String buttonName) {
    return Padding(
      padding: const EdgeInsets.only(left: 24.0, right: 24.0, bottom: 24),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            minimumSize: Size(MediaQuery.of(context).size.width, 48.0),
            elevation: 5.0,
            primary: AppColors.red,
            padding: const EdgeInsets.only(
              left: 20.0,
              right: 20.0,
              top: 7.0,
              bottom: 7.0,
            ),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(16.0)),
            )),
        child: Text(
          buttonName,
          style: GoogleFonts.quicksand(
            color: AppColors.white,
            textStyle: AppTextStyle.Button1,
          ),
        ),
        onPressed: () async {
          if (_medicalKey.currentState!.validate()) {
            if (mounted) {
              setState(() {
                _isLoading = true;
              });
            }

            String msg = '';
            final bool _vaccineEntryResponse =
                await _cloudStoreDataManagement.addBlood(
                    blood_pressure: _b.text,
                    d_blood_pressure: _db.text,
                    heartbeat: _h.text);

            if (_vaccineEntryResponse) {
              msg = 'User data Entry Successfully';

              /// Calling Local Databases Methods To Intitialize Local Database with required MEthods
              Navigator.pop(context);
            } else {
              msg = 'User Data Not Entry Successfully';
            }
          } else {
            print('Not Validated');
            if (mounted) {
              setState(() {
                _isLoading = false;
              });
            }
          }
        },
      ),
    );
  }
}
