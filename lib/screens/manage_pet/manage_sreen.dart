import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:project1/screens/manage_pet/add_record.dart';
import 'package:project1/screens/manage_pet/record_infomation.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../utils/colors.dart';
import '../../utils/utils.dart';

class ManagePet extends StatefulWidget {
  ManagePet({Key? key}) : super(key: key);

  @override
  State<ManagePet> createState() => _ManagePetState();
}

class _ManagePetState extends State<ManagePet> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  final _eventController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: 44,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: SvgPicture.asset(
                    'assets/images/Vector.svg',
                    height: 18,
                    color: AppColors.black,
                  ),
                ),
                Text(
                  "Timetable",
                  style: GoogleFonts.quicksand(
                    textStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(
                  width: 0,
                ),
              ],
            ),
            TableCalendar(
              firstDay: kFirstDay,
              lastDay: kLastDay,
              focusedDay: _focusedDay,
              calendarFormat: _calendarFormat,
              selectedDayPredicate: (day) {
                return isSameDay(_selectedDay, day);
              },
              onDaySelected: (selectedDay, focusedDay) {
                if (!isSameDay(_selectedDay, selectedDay)) {
                  // Call `setState()` when updating the selected day
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                  });
                  print(_selectedDay);
                  print(_focusedDay);
                }
              },
              onFormatChanged: (format) {
                if (_calendarFormat != format) {
                  // Call `setState()` when updating calendar format
                  setState(() {
                    _calendarFormat = format;
                  });
                }
              },
              onPageChanged: (focusedDay) {
                // No need to call `setState()` here
                _focusedDay = focusedDay;
              },
            ),
            Container(
              width: size.width,
              margin: EdgeInsets.only(left: 24, right: 24, top: 0, bottom: 24),
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('records')
                    .doc(_auth.currentUser!.uid)
                    .collection('record')
                    .where('date',
                        isEqualTo: DateFormat('yMMMMd').format(_selectedDay))
                    .snapshots(),
                builder: (context,
                    AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                        snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (snapshot.data!.docs.length != 0) {
                    return ListView.separated(
                      shrinkWrap: true,
                      itemBuilder: (context, position) {
                        return Container(
                          height: 200,
                          width: size.width,
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: const [
                              BoxShadow(
                                color: AppColors.grey1,
                                blurRadius: 2.0,
                                spreadRadius: 0.0,
                                offset: Offset(
                                  1.0,
                                  1.0,
                                ), // shadow direction: bottom right
                              )
                            ],
                          ),
                          child: Column(
                            children: [
                              SizedBox(
                                height: 12,
                              ),
                              InkWell(
                                onTap: (() {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => recordInfomation(
                                        snap: snapshot.data!.docs[position]
                                            .data(),
                                      ),
                                    ),
                                  );
                                }),
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: 18,
                                    ),
                                    Icon(
                                      Icons.calendar_today,
                                      color: AppColors.grey2,
                                      size: 24,
                                    ),
                                    SizedBox(
                                      width: 8,
                                    ),
                                    Text(
                                      '${snapshot.data!.docs[position].data()['date']},',
                                    ),
                                    Spacer(),
                                    Icon(
                                      Icons.arrow_circle_right,
                                      color: AppColors.grey2,
                                      size: 24,
                                    ),
                                    SizedBox(
                                      width: 18,
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(left: 18, right: 18),
                                child: Divider(
                                  thickness: 0.5,
                                  color: AppColors.grey3,
                                ),
                              ),
                              SizedBox(
                                height: 12,
                              ),
                              Row(
                                children: [
                                  SizedBox(
                                    width: 18,
                                  ),
                                  Container(
                                    height: 24,
                                    width: 90,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: Colors.yellow,
                                    ),
                                    child: Center(
                                      child: Text(
                                        "temp : ${snapshot.data!.docs[position].data()['temp']} * C",
                                        style: TextStyle(fontSize: 12),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  Container(
                                    height: 24,
                                    width: 90,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: Colors.yellow,
                                    ),
                                    child: Center(
                                      child: Text(
                                        "weight : ${snapshot.data!.docs[position].data()['weight']} Kg",
                                        style: TextStyle(
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  Container(
                                    height: 24,
                                    width: 90,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: Colors.yellow,
                                    ),
                                    child: Center(
                                      child: Text(
                                        "fat body : ${snapshot.data!.docs[position].data()['fat']}%",
                                        style: TextStyle(
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin:
                                        EdgeInsets.only(left: 18, right: 18),
                                    child: Divider(
                                      thickness: 0.5,
                                      color: AppColors.grey3,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Container(
                                margin: EdgeInsets.only(left: 18, right: 18),
                                child: Divider(
                                  thickness: 0.5,
                                  color: AppColors.grey3,
                                ),
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Row(
                                children: [
                                  SizedBox(
                                    width: 18,
                                  ),
                                  Text(
                                    "Note",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Row(
                                children: [
                                  SizedBox(
                                    width: 18,
                                  ),
                                  Text(
                                    "${snapshot.data!.docs[position].data()['note']}",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                      separatorBuilder: (context, position) => SizedBox(
                        height: 12,
                      ),
                      itemCount: snapshot.data!.docs.length,
                    );
                  } else {
                    return Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => AddRecord(
                                    dates: _selectedDay,
                                  ),
                                ),
                                (route) => false);
                          },
                          child: Container(
                            height: 125,
                            child: Icon(
                              Iconsax.add_circle,
                              color: Colors.red,
                              size: 35,
                            ),
                          ),
                        ),
                        Text(
                          'Add a daily record',
                          style: TextStyle(
                            color: AppColors.red,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
