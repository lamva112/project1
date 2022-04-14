import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:project1/screens/profile/widget.dart';

import '../../utils/colors.dart';
import '../../utils/fonts.dart';
import '../../utils/utils.dart';

class EditProfileScreen extends StatefulWidget {
  EditProfileScreen({Key? key}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController _firstnameController = TextEditingController();
  final TextEditingController _lastnameController = TextEditingController();
  final TextEditingController phoneEditingController = TextEditingController();
  final TextEditingController aboutEditingController = TextEditingController();
  var maskFormatter = new MaskTextInputFormatter(mask: '+84 ### ### ## ##');
  Uint8List? _image;

  selectImage() async {
    Uint8List im = await pickImage(ImageSource.gallery);
    // set state because we need to display the image we selected on the circle avatar
    setState(() {
      _image = im;
    });
  }

  List<String> items = ['Male', 'Female', 'other'];
  String? selectedItem = 'Male';

  DateTime date = DateTime(2022, 1, 1);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
                width: 160,
              ),
              Text(
                "User profile",
                style: GoogleFonts.quicksand(
                  textStyle: AppTextStyle.Title2,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 16,
          ),
          Row(
            children: [
              SizedBox(
                width: 160,
              ),
              Stack(
                overflow: Overflow.visible,
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
          SizedBox(
            height: 20,
          ),
          Row(
            children: [
              SizedBox(
                width: 24,
              ),
              Text(
                "First Name",
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
                return 'First Name must be at least 3 characters';
              return null;
            },
            size: size,
            textEditingController: _firstnameController,
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
                "Last Name",
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
                return 'First name must be at least 3 characters';
              return null;
            },
            size: size,
            textEditingController: _lastnameController,
          ),
          SizedBox(
            height: 24,
          ),
          Row(
            children: [
              SizedBox(
                width: 24,
              ),
              Container(
                width: size.width / 2 - 20,
                height: 22,
                child: Text(
                  "Date of Birth",
                  style: GoogleFonts.quicksand(
                    textStyle: AppTextStyle.Body3,
                  ),
                ),
              ),
              Container(
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
              SizedBox(
                width: 24,
              ),
              DatePickerButton(context),
              SizedBox(
                width: 10,
              ),
              SexDropdownButton(size),
            ],
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
                "Phone number",
                style: GoogleFonts.quicksand(
                  textStyle: AppTextStyle.Body3,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 8,
          ),
          PhoneTextField(size),
          SizedBox(
            height: 24,
          ),
          Row(
            children: [
              SizedBox(
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
          SizedBox(
            height: 8,
          ),
          TextFieldInput(
            validator: (String? inputVal) {
              if (inputVal!.length < 6)
                return 'about must be at least 3 characters';
              return null;
            },
            size: size,
            textEditingController: aboutEditingController,
          ),
        ]),
      ),
    );
  }

  Container PhoneTextField(Size size) {
    return Container(
      margin: EdgeInsets.only(left: 24, right: 24),
      width: size.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(7),
        color: AppColors.grey3.withAlpha(50),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 16),
        child: TextFormField(
          cursorColor: AppColors.red,
          controller: phoneEditingController,
          decoration: InputDecoration(
            hintStyle: TextStyle(color: AppColors.black),
            border: InputBorder.none,
          ),
          inputFormatters: [maskFormatter],
        ),
      ),
    );
  }

  Container SexDropdownButton(Size size) {
    return Container(
      margin: EdgeInsets.only(left: 0, right: 0),
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
    );
  }
}
