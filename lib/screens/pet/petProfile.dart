import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:project1/screens/pet/vaccineinfomation.dart';

import '../../resources/cloud_data_management.dart';
import '../../utils/colors.dart';
import '../../utils/fonts.dart';
import '../../utils/loading_widget.dart';
import '../../utils/utils.dart';
import '../profile/widget.dart';

class PetProfileScreen extends StatefulWidget {
  PetProfileScreen({Key? key}) : super(key: key);

  @override
  State<PetProfileScreen> createState() => _PetProfileScreenState();
}

class _PetProfileScreenState extends State<PetProfileScreen> {
  final GlobalKey<FormState> _EditKey = GlobalKey<FormState>();
  final TextEditingController _name = TextEditingController();
  final TextEditingController _breed = TextEditingController();
  final TextEditingController _color = TextEditingController();
  Uint8List? _image;

  final CloudStoreDataManagement _cloudStoreDataManagement =
      CloudStoreDataManagement();

  selectImage() async {
    Uint8List im = await pickImage(ImageSource.gallery);
    // set state because we need to display the image we selected on the circle avatar
    setState(() {
      _image = im;
    });
  }

  List<String> items = ['Male', 'Female'];
  String? selectedItem = 'Male';

  DateTime date = DateTime(2022, 1, 1);
  bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _name.dispose();
    _breed.dispose();
    _color.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.grey6,
      body: SingleChildScrollView(
        child: Form(
          key: _EditKey,
          child: _isLoading
              ? Center(child: LoadingWidget())
              : Column(
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
                          width: 110,
                        ),
                        Text(
                          "Pet profile",
                          style: GoogleFonts.quicksand(
                            textStyle: AppTextStyle.Title2,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    _isLoading
                        ? LoadingWidget()
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Stack(
                                overflow: Overflow.visible,
                                children: [
                                  _image != null
                                      ? ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(16),
                                          child: Image.memory(
                                            _image!,
                                            width: 159,
                                            height: 159,
                                            fit: BoxFit.cover,
                                          ),
                                        )
                                      : ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(16),
                                          child: Image.network(
                                            'https://i.stack.imgur.com/l60Hf.png',
                                            width: 159,
                                            height: 159,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                  Positioned(
                                    bottom: -25,
                                    left: 55,
                                    child: IconButton(
                                      onPressed: selectImage,
                                      icon: SvgPicture.asset(
                                        'assets/images/camera.svg',
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: 24,
                        ),
                        Text(
                          "Name",
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
                          return 'Full Name must be at least 3 characters';
                        return null;
                      },
                      size: size,
                      textEditingController: _name,
                    ),
                    SizedBox(
                      height: 24,
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: 24,
                        ),
                        Text(
                          "Breed",
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
                        if (inputVal!.length < 6)
                          return 'User Name must be at least 3 characters';
                        return null;
                      },
                      size: size,
                      textEditingController: _breed,
                    ),
                    SizedBox(
                      height: 24,
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: 24,
                        ),
                        Text(
                          "Gender",
                          style: GoogleFonts.quicksand(
                            textStyle: AppTextStyle.Body3,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    SexDropdownButton(size),
                    SizedBox(
                      height: 24,
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: 24,
                        ),
                        Text(
                          "Color",
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
                        if (inputVal!.length < 1)
                          return 'Colors cannot be empty';
                        return null;
                      },
                      size: size,
                      textEditingController: _color,
                    ),
                    SizedBox(
                      height: 24,
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: 24,
                        ),
                        Text(
                          "Birthday",
                          style: GoogleFonts.quicksand(
                            textStyle: AppTextStyle.Body3,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    DatePickerButton(context),
                    SizedBox(
                      height: 24,
                    ),
                    signUpAuthButton(context, "Confirm"),
                  ],
                ),
        ),
      ),
    );
  }

  Container SexDropdownButton(Size size) {
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

  Widget DatePickerButton(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 24, right: 24),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            minimumSize: Size(MediaQuery.of(context).size.width, 48.0),
            elevation: 0.0,
            primary: AppColors.grey5,
            padding: EdgeInsets.only(
              left: 20.0,
              right: 20.0,
              top: 7.0,
              bottom: 7.0,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(7.0)),
            )),
        child: Text(
          '${date.day}/${date.month}/${date.year}',
          style: GoogleFonts.quicksand(
            textStyle: AppTextStyle.Button1,
          ),
        ),
        onPressed: () async {
          DateTime? newDate = await showDatePicker(
              context: context,
              initialDate: date,
              firstDate: DateTime(1900),
              lastDate: DateTime(2100));
          if (newDate == null) return;

          setState(() {
            date = newDate;
          });
        },
      ),
    );
  }

  Widget signUpAuthButton(BuildContext context, String buttonName) {
    return Container(
      margin: EdgeInsets.only(left: 24, right: 24),
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
          if (_EditKey.currentState!.validate()) {
            print('Validated');
            if (mounted) {
              setState(() {
                this._isLoading = true;
              });
            }
            String msg = '';
            final bool _userEntryResponse =
                await _cloudStoreDataManagement.registerNewPet(
              name: this._name.text,
              breed: this._breed.text,
              gender: selectedItem.toString(),
              color: this._color.text,
              dateofbrith: date.toString(),
              file: _image!,
            );

            if (_userEntryResponse) {
              msg = 'User data Entry Successfully';

              /// Calling Local Databases Methods To Intitialize Local Database with required MEthods
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (_) => VacctioninfomationScreen(
                      petname: _name.text,
                    ),
                  ),
                  (route) => false);
            } else
              msg = 'User Data Not Entry Successfully';

            if (mounted) {
              setState(() {
                this._isLoading = false;
              });
            }
          } else {
            print('Not Validated');
          }
        },
      ),
    );
  }
}
