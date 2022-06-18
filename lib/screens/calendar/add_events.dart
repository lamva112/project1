import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:intl/intl.dart';
import 'package:project1/resources/cloud_data_management.dart';
import 'package:project1/screens/calendar/canlendar_screen.dart';
import 'package:project1/screens/profile/widget.dart';
import 'package:project1/utils/loading_widget.dart';
import 'package:project1/utils/utils.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:time_range_picker/time_range_picker.dart';

class AddTimeTableScreen extends StatefulWidget {
  AddTimeTableScreen({Key? key}) : super(key: key);

  @override
  State<AddTimeTableScreen> createState() => _AddTimeTableScreenState();
}

class _AddTimeTableScreenState extends State<AddTimeTableScreen> {
  final GlobalKey<FormState> _TimetableKey = GlobalKey<FormState>();
  final TextEditingController _title = TextEditingController();
  final TextEditingController _des = TextEditingController();
  CalendarFormat _calendarFormat = CalendarFormat.month;
  List<int> colorCollection = <int>[];
  DateTime date = DateTime.now();
  TimeOfDay startTime = TimeOfDay.now();
  TimeOfDay endTime = TimeOfDay.now();
  bool status = false;
  final Random random = new Random();
  bool isLoading = false;

  void AddTasks(
    String dates,
    String des,
    String title,
    String startTime,
    String endTime,
    bool remind,
    int startHour,
  ) async {
    setState(() {
      isLoading = true;
    });
    // start the loading
    try {
      // upload to storage and db
      String res = await CloudStoreDataManagement().AddTask(
        dates: dates,
        des: des,
        title: title,
        startTime: startTime,
        endTime: endTime,
        remind: remind,
        startHour: startHour,
      );
      if (res == "success") {
        setState(() {
          isLoading = false;
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => CalendarScreen(),
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
      body: Form(
        key: _TimetableKey,
        child: isLoading
            ? const LoadingWidget()
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 44,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Add Timetable',
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
                              'Title*',
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
                            if (inputVal!.length < 3) {
                              // ignore: lines_longer_than_80_chars
                              return 'Title must be at least 3 characters';
                            }
                            return null;
                          },
                          size: size,
                          textEditingController: _title,
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
                              'Decription*',
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
                            if (inputVal!.length < 3) {
                              // ignore: lines_longer_than_80_chars
                              return 'Decription must be at least 3 characters';
                            }
                            return null;
                          },
                          size: size,
                          textEditingController: _des,
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
                              'Add date',
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
                        DatePickerButton(context),
                        SizedBox(
                          height: 16,
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: 24,
                            ),
                            Text(
                              'Add time',
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
                        Container(
                          margin: EdgeInsets.only(left: 24, right: 24),
                          child: SizedBox(
                            width: size.width,
                            height: 48,
                            // ignore: lines_longer_than_80_chars
                            child: ElevatedButton(
                              onPressed: () async {
                                TimeRange? result = await showCupertinoDialog(
                                  barrierDismissible: true,
                                  context: context,
                                  builder: (BuildContext context) {
                                    TimeOfDay _startTime = TimeOfDay.now();
                                    TimeOfDay _endTime = TimeOfDay.now();
                                    return CupertinoAlertDialog(
                                      content: Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          height: 340,
                                          child: Column(
                                            children: [
                                              TimeRangePicker(
                                                padding: 22,
                                                hideButtons: true,
                                                handlerRadius: 8,
                                                strokeWidth: 4,
                                                ticks: 12,
                                                activeTimeTextStyle: TextStyle(
                                                  fontWeight: FontWeight.normal,
                                                  fontSize: 22,
                                                  color: Colors.white,
                                                ),
                                                timeTextStyle: TextStyle(
                                                  fontWeight: FontWeight.normal,
                                                  fontSize: 22,
                                                  color: Colors.white70,
                                                ),
                                                onStartChange: (start) {
                                                  setState(() {
                                                    _startTime = start;
                                                  });
                                                },
                                                onEndChange: (end) {
                                                  setState(() {
                                                    _endTime = end;
                                                  });
                                                },
                                              ),
                                            ],
                                          )),
                                      actions: <Widget>[
                                        CupertinoDialogAction(
                                            isDestructiveAction: true,
                                            child: Text('Cancel'),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            }),
                                        CupertinoDialogAction(
                                          child: Text('Ok'),
                                          onPressed: () {
                                            Navigator.of(context).pop(
                                              TimeRange(
                                                startTime: _startTime,
                                                endTime: _endTime,
                                              ),
                                            );
                                            setState(() {
                                              startTime = _startTime;
                                              endTime = _endTime;
                                            });
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                                print(result.toString());
                              },
                              child: Text(
                                  '${startTime.format(context)} - ${endTime.format(context)}'),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 24,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 24, right: 24),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Remind',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal),
                              ),
                              Spacer(),
                              FlutterSwitch(
                                width: 55.0,
                                height: 25.0,
                                valueFontSize: 12.0,
                                toggleSize: 18.0,
                                activeColor: Colors.red,
                                inactiveColor: Colors.grey,
                                value: status,
                                onToggle: (val) {
                                  setState(() {
                                    status = val;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
      bottomSheet: signUpAuthButton(context, 'Save Your Task'),
    );
  }

  Widget DatePickerButton(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 24, right: 24),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            minimumSize: Size(MediaQuery.of(context).size.width, 48.0),
            elevation: 0.0,
            primary: Colors.grey,
            padding: const EdgeInsets.only(
              left: 20.0,
              right: 20.0,
              top: 7.0,
              bottom: 7.0,
            ),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(7.0)),
            )),
        child: Row(
          children: [
            Text(
              '${date.day}/${date.month}/${date.year}',
            ),
          ],
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
          if (_TimetableKey.currentState!.validate()) {
            print('Validated');
            AddTasks(
              DateFormat('yMMMMd').format(date),
              _des.text,
              _title.text,
              startTime.format(context).toString(),
              endTime.format(context).toString(),
              status,
              startTime.hour,
            );
          } else {
            print('Not Validated');
          }
        },
      ),
    );
  }
}
