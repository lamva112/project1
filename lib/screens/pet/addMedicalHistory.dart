import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project1/resources/cloud_data_management.dart';
import 'package:project1/screens/pet/medicalHistory.dart';
import 'package:project1/utils/fonts.dart';
import 'package:project1/utils/loading_widget.dart';

import '../../utils/colors.dart';
import '../profile/widget.dart';

class AddMedicalHistoryScreen extends StatefulWidget {
  final String petname;
  const AddMedicalHistoryScreen({Key? key, required this.petname}) : super(key: key);

  @override
  State<AddMedicalHistoryScreen> createState() =>
      _AddMedicalHistoryScreenState();
}

class _AddMedicalHistoryScreenState extends State<AddMedicalHistoryScreen> {
  final GlobalKey<FormState> _medicalKey = GlobalKey<FormState>();
  final TextEditingController _name = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  List<String> items = ['Process', 'Recover'];
  String? selectedItem = 'Process';
  bool _isLoading = false;

  final CloudStoreDataManagement _cloudStoreDataManagement =
      CloudStoreDataManagement();

  @override
  void dispose() {
    super.dispose();
    _name.dispose();
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
                          "Medical History",
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
                          "Name Of Diseases  ",
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
                        if (inputVal!.length < 3) {
                          return 'Name Of Disease must be at least 3 characters';
                        }
                        return null;
                      },
                      size: size,
                      textEditingController: _name,
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
                          "Status",
                          style: GoogleFonts.quicksand(
                            textStyle: AppTextStyle.Body3,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    InJectDropdownButton(size),
                  ],
                ),
              ),
      ),
      bottomSheet: SaveButton(context, 'save'),
    );
  }

  Container InJectDropdownButton(Size size) {
    return Container(
      margin: const EdgeInsets.only(left: 24, right: 24),
      width: size.width,
      height: 48.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(7),
        color: AppColors.grey3.withAlpha(50),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.only(left: 16, right: 16),
          child: DropdownButton(
            underline: Container(),
            isDense: true,
            elevation: 0,
            isExpanded: true,
            value: selectedItem,
            items: items
                .map(
                  (item) => DropdownMenuItem(
                    value: item,
                    child: Text(
                      item,
                      style: GoogleFonts.quicksand(
                        textStyle: AppTextStyle.Body3,
                      ),
                    ),
                  ),
                )
                .toList(),
            onChanged: (String? item) {
              setState(() {
                selectedItem = item;
                print('$selectedItem');
              });
            },
          ),
        ),
      ),
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
            print('Validated asfasdfsad  ${widget.petname}');

            if (mounted) {
              setState(() {
                _isLoading = true;
              });
            }

            String msg = '';
            final bool _vaccineEntryResponse =
                await _cloudStoreDataManagement.Diseases(
              petName: widget.petname,
              DisName: _name.text,
              status: selectedItem.toString(),
            );

            if (_vaccineEntryResponse) {
              msg = 'User data Entry Successfully';

              /// Calling Local Databases Methods To Intitialize Local Database with required MEthods
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (_) => MedicalHistoryScreen(
                      petname: widget.petname,
                    ),
                  ),
                  (route) => false);
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
