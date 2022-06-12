import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import 'package:project1/screens/profile/widget.dart';

import '../../resources/cloud_data_management.dart';
import '../../utils/colors.dart';
import '../../utils/fonts.dart';
import '../../utils/loading_widget.dart';
import '../../utils/utils.dart';
import '../mainscreen/mainscreen.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final GlobalKey<FormState> _EditKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _phoneEditingController = TextEditingController();
  final TextEditingController _aboutEditingController = TextEditingController();
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

  List<String> items = ['Male', 'Female', 'other'];
  String? selectedItem = 'Male';

  DateTime date = DateTime.now();
  bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _usernameController.dispose();
    _phoneEditingController.dispose();
    _aboutEditingController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: _EditKey,
          child: _isLoading
              ? const Center(child: LoadingWidget())
              : Column(
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
                          width: 110,
                        ),
                        Text(
                          "User profile",
                          style: GoogleFonts.quicksand(
                            textStyle: AppTextStyle.Title2,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            _image != null
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(16),
                                    child: Image.memory(
                                      _image!,
                                      width: 159,
                                      height: 159,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : ClipRRect(
                                    borderRadius: BorderRadius.circular(16),
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
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        const SizedBox(
                          width: 24,
                        ),
                        Text(
                          "Full Name",
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
                        if (inputVal!.length < 6) {
                          return 'Full Name must be at least 3 characters';
                        }
                        return null;
                      },
                      size: size,
                      textEditingController: _nameController,
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    Row(
                      children: [
                        const SizedBox(
                          width: 24,
                        ),
                        Text(
                          "User Name",
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
                        if (inputVal!.length < 6) {
                          return 'User Name must be at least 3 characters';
                        }
                        return null;
                      },
                      size: size,
                      textEditingController: _usernameController,
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    Row(
                      children: [
                        const SizedBox(
                          width: 24,
                        ),
                        SizedBox(
                          width: size.width / 2 - 20,
                          height: 22,
                          child: Text(
                            "Date of Birth",
                            style: GoogleFonts.quicksand(
                              textStyle: AppTextStyle.Body3,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: size.width / 2 - 30,
                          height: 22,
                          child: Text(
                            "Gender",
                            style: GoogleFonts.quicksand(
                              textStyle: AppTextStyle.Body3,
                            ),
                          ),
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(
                          width: 24,
                        ),
                        DatePickerButton(context),
                        const SizedBox(
                          width: 10,
                        ),
                        SexDropdownButton(size),
                      ],
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    Row(
                      children: [
                        const SizedBox(
                          width: 24,
                        ),
                        Text(
                          "Phone number",
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
                        if (inputVal!.length < 10) {
                          return 'Phone must be at least 10 characters';
                        }
                        return null;
                      },
                      size: size,
                      textEditingController: _phoneEditingController,
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    Row(
                      children: [
                        const SizedBox(
                          width: 24,
                        ),
                        Text(
                          "About",
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
                        if (inputVal!.length < 6) {
                          return 'about must be at least 3 characters';
                        }
                        return null;
                      },
                      size: size,
                      textEditingController: _aboutEditingController,
                    ),
                    const SizedBox(
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
      margin: const EdgeInsets.only(left: 0, right: 0),
      width: size.width / 2 - 30,
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
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          minimumSize: Size(MediaQuery.of(context).size.width / 2 - 30, 48.0),
          elevation: 0.0,
          primary: AppColors.grey5,
          padding: const EdgeInsets.only(
            left: 20.0,
            right: 20.0,
            top: 7.0,
            bottom: 7.0,
          ),
          shape: const RoundedRectangleBorder(
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
    );
  }

  Widget signUpAuthButton(BuildContext context, String buttonName) {
    return Padding(
      padding: const EdgeInsets.only(left: 24.0, right: 24.0),
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
          if (_EditKey.currentState!.validate()) {
            print('Validated');
            if (mounted) {
              setState(() {
                _isLoading = true;
              });
            }

            String msg = '';

            final bool doesUserExist = await _cloudStoreDataManagement
                .checkThisUser(userName: _usernameController.text);

            if (doesUserExist == true) {
              msg = 'User Name Already Present';
            } else {
              final bool _userEntryResponse =
                  await _cloudStoreDataManagement.registerNewUser(
                fullname: _nameController.text,
                userName: _usernameController.text,
                phone: _phoneEditingController.text,
                bio: _aboutEditingController.text,
                file: _image!,
                male: selectedItem.toString(),
                dateofbirth: date.toString(),
              );

              if (_userEntryResponse) {
                msg = 'User data Entry Successfully';

                /// Calling Local Databases Methods To Intitialize Local Database with required MEthods

                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const MainScreen(),
                    ),
                    (route) => false);
              } else {
                msg = 'User Data Not Entry Successfully';
              }
            }

            showSnackBar(context, msg);
            if (mounted) {
              setState(() {
                _isLoading = true;
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
