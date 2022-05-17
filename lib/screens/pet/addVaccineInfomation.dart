import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project1/screens/pet/vaccineinfomation.dart';
import 'package:project1/screens/profile/widget.dart';
import 'package:project1/utils/colors.dart';
import 'package:project1/utils/loading_widget.dart';

import '../../resources/cloud_data_management.dart';
import '../../resources/firestore_methods.dart';
import '../../utils/fonts.dart';
import '../../utils/utils.dart';

class AddVaccineScreen extends StatefulWidget {
  final String petname;
  AddVaccineScreen({Key? key, required this.petname}) : super(key: key);

  @override
  State<AddVaccineScreen> createState() => _AddVaccineScreenState();
}

class _AddVaccineScreenState extends State<AddVaccineScreen> {
  final GlobalKey<FormState> _VaccineKey = GlobalKey<FormState>();
  final TextEditingController _name = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  List<String> items = ['1 inject', '2 inject', '3 inject', 'completed'];
  String? selectedItem = '1 inject';
  bool _isLoading = false;
  var petData = {};
  final CloudStoreDataManagement _cloudStoreDataManagement =
      CloudStoreDataManagement();

  @override
  void dispose() {
    super.dispose();
    _name.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppColors.grey6,
      body: Form(
        key: _VaccineKey,
        child: _isLoading
            ? Center(child: LoadingWidget())
            : Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 51,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 16,
                        ),
                        SvgPicture.asset(
                          'assets/images/Vector.svg',
                          height: 24,
                        ),
                        SizedBox(
                          width: 65,
                        ),
                        Text(
                          "Vaccination Information",
                          style: GoogleFonts.quicksand(
                            textStyle: AppTextStyle.Title2,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 38,
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: 24,
                        ),
                        Text(
                          "Name Vaccination ",
                          style: GoogleFonts.quicksand(
                            textStyle: AppTextStyle.Body3,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    TextFieldInput(
                      validator: (String? inputVal) {
                        if (inputVal!.length < 3)
                          return 'Name of vaccination must be at least 3 characters';
                        return null;
                      },
                      size: size,
                      textEditingController: _name,
                    ),
                    SizedBox(
                      height: 32,
                    ),
                    Row(
                      children: [
                        SizedBox(
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
                    SizedBox(
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
      margin: EdgeInsets.only(left: 24, right: 24),
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
            padding: EdgeInsets.only(
              left: 20.0,
              right: 20.0,
              top: 7.0,
              bottom: 7.0,
            ),
            shape: RoundedRectangleBorder(
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
          if (_VaccineKey.currentState!.validate()) {
            print('Validated asfasdfsad  ${widget.petname}');

            if (mounted) {
              setState(() {
                this._isLoading = true;
              });
            }

            String msg = '';
            final bool _vaccineEntryResponse =
                await _cloudStoreDataManagement.addVacine(
              petName: widget.petname,
              VccName: _name.text,
              status: selectedItem.toString(),
            );

            if (_vaccineEntryResponse) {
              msg = 'User data Entry Successfully';

              /// Calling Local Databases Methods To Intitialize Local Database with required MEthods
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (_) => VacctioninfomationScreen(
                      petname: widget.petname,
                    ),
                  ),
                  (route) => false);
            } else
              msg = 'User Data Not Entry Successfully';
          } else {
            print('Not Validated');
            if (mounted) {
              setState(() {
                this._isLoading = false;
              });
            }
          }
        },
      ),
    );
  }
}
