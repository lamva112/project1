import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:intl/intl.dart';
import 'package:project1/screens/mainscreen/mainscreen.dart';
import 'package:project1/screens/profile/widget.dart';

import '../../resources/cloud_data_management.dart';
import '../../utils/utils.dart';
import 'manage_sreen.dart';

class AddRecord extends StatefulWidget {
  DateTime dates;
  AddRecord({Key? key, required this.dates}) : super(key: key);

  @override
  State<AddRecord> createState() => _AddRecordState();
}

class _AddRecordState extends State<AddRecord> {
  final GlobalKey<FormState> _recordtableKey = GlobalKey<FormState>();
  final TextEditingController _temp = TextEditingController();
  final TextEditingController _weight = TextEditingController();
  final TextEditingController _fat = TextEditingController();
  final TextEditingController _medical = TextEditingController();
  final TextEditingController _medicine = TextEditingController();
  final TextEditingController _height = TextEditingController();
  final TextEditingController _witdth = TextEditingController();
  final TextEditingController _meal = TextEditingController();
  final TextEditingController _note = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool isLoading = false;

  void AddRecord({
    required String dates,
    required String temp,
    required String weight,
    required String fat,
    required String neck,
    required String waist,
    required String height,
    required String width,
    required String meal,
    required String note,
    required String uid,
  }) async {
    setState(() {
      isLoading = true;
    });
    // start the loading
    try {
      // upload to storage and db
      String res = await CloudStoreDataManagement().AddRecord(
          dates: dates,
          temp: temp,
          weight: weight,
          fat: fat,
          neck: neck,
          waist: waist,
          height: height,
          width: width,
          meal: meal,
          note: note,
          uid: uid);

      if (res == "success") {
        setState(() {
          isLoading = false;
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => MainScreen(),
            ),
          );
        });
        showSnackBar(
          context,
          'Posted!',
        );
      } else {
        showSnackBar(context, res);
      }
    } catch (err) {
      setState(() {
        isLoading = false;
      });
      showSnackBar(
        context,
        err.toString(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: _recordtableKey,
          child: Column(
            children: [
              SizedBox(
                height: 44,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Add Daily Record',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 40,
              ),
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 24,
                        ),
                        Text(
                          'standard body temperature*',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
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
                          // ignore: lines_longer_than_80_chars
                          return 'standard body temperature must be at least 1 characters';
                        }
                        return null;
                      },
                      size: size,
                      textEditingController: _temp,
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: 24,
                        ),
                        Text(
                          'body weight*',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
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
                          // ignore: lines_longer_than_80_chars
                          return 'body weight must be at least 1 characters';
                        }
                        return null;
                      },
                      size: size,
                      textEditingController: _weight,
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: 24,
                        ),
                        Text(
                          'fat body',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
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
                          // ignore: lines_longer_than_80_chars
                          return 'fat body must be at least 1 characters';
                        }
                        return null;
                      },
                      size: size,
                      textEditingController: _fat,
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: 24,
                        ),
                        Text(
                          'medical treatment',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
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
                          // ignore: lines_longer_than_80_chars
                          return 'around the neck must be at least 1 characters';
                        }
                        return null;
                      },
                      size: size,
                      textEditingController: _medical,
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: 24,
                        ),
                        Text(
                          'Take medicines',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
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
                          // ignore: lines_longer_than_80_chars
                          return 'around the waist must be at least 1 characters';
                        }
                        return null;
                      },
                      size: size,
                      textEditingController: _medicine,
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: 24,
                        ),
                        Text(
                          'body height',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
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
                          // ignore: lines_longer_than_80_chars
                          return 'body height must be at least 1 characters';
                        }
                        return null;
                      },
                      size: size,
                      textEditingController: _height,
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: 24,
                        ),
                        Text(
                          'body width',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
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
                          // ignore: lines_longer_than_80_chars
                          return 'body width must be at least 1 characters';
                        }
                        return null;
                      },
                      size: size,
                      textEditingController: _witdth,
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: 24,
                        ),
                        Text(
                          'meal',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
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
                          // ignore: lines_longer_than_80_chars
                          return 'meal width must be at least 1 characters';
                        }
                        return null;
                      },
                      size: size,
                      textEditingController: _meal,
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: 24,
                        ),
                        Text(
                          'note',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
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
                          // ignore: lines_longer_than_80_chars
                          return 'note width must be at least 1 characters';
                        }
                        return null;
                      },
                      size: size,
                      textEditingController: _note,
                    ),
                    SizedBox(
                      height: 120,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomSheet: signUpAuthButton(context, 'Save Your Record'),
    );
  }

  Widget signUpAuthButton(BuildContext context, String buttonName) {
    return Padding(
      padding: const EdgeInsets.only(left: 24.0, right: 24.0, bottom: 28),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            minimumSize: Size(MediaQuery.of(context).size.width, 48.0),
            elevation: 5.0,
            primary: Colors.red,
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
        ),
        onPressed: () async {
          if (_recordtableKey.currentState!.validate()) {
            print('Validated');
            AddRecord(
              dates: DateFormat('yMMMMd').format(widget.dates),
              temp: _temp.text,
              weight: _weight.text,
              fat: _fat.text,
              neck: _medical.text,
              waist: _medicine.text,
              height: _height.text,
              width: _witdth.text,
              meal: _meal.text,
              note: _note.text,
              uid: _auth.currentUser!.uid,
            );
          } else {
            print('Not Validated');
          }
        },
      ),
    );
  }
}
