import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:project1/screens/calendar/add_events.dart';
import 'package:project1/screens/mainscreen/mainscreen.dart';
import 'package:project1/utils/colors.dart';
import 'package:project1/utils/fonts.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'dart:math';

import '../../utils/utils.dart';

class CalendarScreen extends StatefulWidget {
  CalendarScreen({Key? key}) : super(key: key);

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  final _eventController = TextEditingController();
  List<Color> colorCollection = <Color>[];
  final Random random = new Random();
  late TabController tabController;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  void initState() {
    _initializeEventColor();
    super.initState();
  }

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
                  child: InkWell(
                    onTap: (() => Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (_) => MainScreen(),
                        ),
                        (route) => false)),
                    child: SvgPicture.asset(
                      'assets/images/Vector.svg',
                      height: 18,
                      color: AppColors.black,
                    ),
                  ),
                ),
                Text(
                  "Daily record",
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: Text(
                    'TimeTable',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                InkWell(
                  onTap: (() {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (_) => AddTimeTableScreen(),
                        ),
                        (route) => false);
                  }),
                  child: Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: Colors.red,
                      ),
                      child: Icon(
                        Icons.add,
                        size: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 24,
            ),
            Container(
              width: size.width,
              margin: EdgeInsets.only(left: 24, right: 24, top: 0, bottom: 24),
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('pets')
                    .doc(_auth.currentUser?.uid)
                    .collection('tasks')
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
                  return ListView.separated(
                    shrinkWrap: true,
                    itemBuilder: (context, position) {
                      return Container(
                        height: 112,
                        width: 132,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            _buildTimeline(colorCollection[position]),
                            SizedBox(
                              width: 12,
                            ),
                            Container(
                              width: 303,
                              height: 202,
                              child: Container(
                                margin: EdgeInsets.only(
                                    top: 16, right: 12, left: 12),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${snapshot.data!.docs[position].data()['startTime']} - ${snapshot.data!.docs[position].data()['endTime']}',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 11,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    SizedBox(
                                      height: 8,
                                    ),
                                    Text(
                                      '${snapshot.data!.docs[position].data()['title']},',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 8,
                                    ),
                                    Flexible(
                                      child: Text(
                                        '${snapshot.data!.docs[position].data()['des']},',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              decoration: BoxDecoration(
                                color: colorCollection[position],
                                borderRadius: BorderRadius.circular(16),
                              ),
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
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeline(Color color) {
    return Container(
      height: 112,
      width: 10,
      child: TimelineTile(
        alignment: TimelineAlign.manual,
        lineXY: 0,
        isFirst: true,
        indicatorStyle: IndicatorStyle(
            indicatorXY: 0,
            width: 10,
            height: 10,
            indicator: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(width: 5, color: color),
              ),
            )),
        afterLineStyle: LineStyle(
          thickness: 2,
          color: color,
        ),
      ),
    );
  }

  void _initializeEventColor() {
    colorCollection.add(Color(0xFFF2B161));
    colorCollection.add(Color(0xFF80C8F8));
    colorCollection.add(Color(0xFF01A1EF));
    colorCollection.add(Color(0xFFF394F4));
    colorCollection.add(Color(0xFF8B1FA9));
    colorCollection.add(Color(0xFFD20100));
    colorCollection.add(Color(0xFFFC571D));
    colorCollection.add(Color(0xFF36B37B));
    colorCollection.add(Color(0xFF01A1EF));
    colorCollection.add(Color(0xFF3D4FB5));
    colorCollection.add(Color(0xFFE47C73));
    colorCollection.add(Color(0xFF636363));
    colorCollection.add(Color(0xFF0A8043));
  }
}
