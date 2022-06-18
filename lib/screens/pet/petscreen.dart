import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:project1/provider/pet_provider.dart';
import 'package:project1/resources/cloud_data_management.dart';
import 'package:project1/screens/calendar/canlendar_screen.dart';
import 'package:project1/screens/pet/petProfile.dart';
import 'package:project1/screens/pet/pet_infomation_screen.dart';
import 'package:project1/utils/colors.dart';
import 'package:project1/utils/fonts.dart';
import 'package:project1/utils/utils.dart';
import 'package:provider/provider.dart';
import 'package:timeline_tile/timeline_tile.dart';

class PetScreen extends StatefulWidget {
  const PetScreen({Key? key}) : super(key: key);

  @override
  State<PetScreen> createState() => _PetScreenState();
}

class _PetScreenState extends State<PetScreen> {
  var userData = {};
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late bool hasdata;
  final CloudStoreDataManagement _cloudStoreDataManagement =
      CloudStoreDataManagement();
  bool _isLoading = false;
  List<Color> colorCollection = [];

  DateTime _today = DateTime.now();
  final Random random = new Random();
  @override
  void initState() {
    super.initState();
    _initializeEventColor();
    checkPet();
    getData();
  }

  checkPet() async {
    hasdata = await _cloudStoreDataManagement.petPresentOrNot(
        uid: _auth.currentUser!.uid);
  }

  getData() async {
    setState(() {
      _isLoading = true;
    });
    try {
      var userSnap = await FirebaseFirestore.instance
          .collection('pets')
          .doc(_auth.currentUser!.uid)
          .get();

      // get post lENGTH

      userData = userSnap.data()!;

      setState(() {});
    } catch (e) {}
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // final PetProvider petProvider = Provider.of<PetProvider>(context);
    Size sizes = MediaQuery.of(context).size;
    return _isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            backgroundColor: AppColors.grey6,
            extendBodyBehindAppBar: true,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              actions: [
                hasdata
                    ? PopupMenuButton(
                        elevation: 0,
                        color: Colors.transparent,
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 20),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  InkWell(
                                    onTap: () => Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => PetInfomationScreen(),
                                      ),
                                      (route) => false,
                                    ),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: AppColors.white,
                                          borderRadius:
                                              BorderRadius.circular(8)),
                                      width: 100,
                                      height: 30,
                                      child: const Center(
                                        child: Text('Pet profile'),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      )
                    : Container(),
              ],
            ),
            body: hasdata
                ? SingleChildScrollView(
                    child: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Stack(
                            clipBehavior: Clip.none,
                            children: [
                              SizedBox(
                                width: sizes.width,
                                height: 342,
                                child: Image.network(
                                  userData['petUrl'],
                                  fit: BoxFit.cover,
                                  width: 280.0,
                                ),
                              ),
                              Positioned(
                                bottom: -60,
                                right: 12,
                                left: 12,
                                child: Container(
                                  margin: const EdgeInsets.only(
                                      left: 22, right: 22),
                                  width: sizes.width,
                                  height: 119,
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
                                  child: Container(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        const SizedBox(
                                          height: 24,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 24),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    userData['name'],
                                                    style:
                                                        GoogleFonts.quicksand(
                                                      textStyle: TextStyle(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 18,
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 2,
                                                  ),
                                                  Text(
                                                    userData['breed'],
                                                    style:
                                                        GoogleFonts.quicksand(
                                                      textStyle:
                                                          AppTextStyle.Body1,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 23),
                                              child: userData['gender'] ==
                                                      'Male'
                                                  ? const Icon(
                                                      Icons.male,
                                                      size: 24,
                                                      color: AppColors.green,
                                                    )
                                                  : const Icon(
                                                      Icons.female,
                                                      size: 24,
                                                      color: AppColors.red,
                                                    ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 16,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 24, right: 14),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "Age:4 month",
                                                style: GoogleFonts.quicksand(
                                                  textStyle: AppTextStyle.Body2,
                                                ),
                                              ),
                                              Text(
                                                "Weight: 4kg",
                                                style: GoogleFonts.quicksand(
                                                  textStyle: AppTextStyle.Body2,
                                                ),
                                              ),
                                              Text(
                                                "Color: ${userData['color']}",
                                                style: GoogleFonts.quicksand(
                                                  textStyle: AppTextStyle.Body2,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 84,
                          ),
                          Container(
                            padding: EdgeInsets.only(left: 24, right: 24),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "My tasks",
                                  style: GoogleFonts.quicksand(
                                    textStyle: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: (() => Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => CalendarScreen(),
                                      ),
                                      (route) => false)),
                                  child: Text(
                                    "See all",
                                    style: GoogleFonts.quicksand(
                                      textStyle: TextStyle(
                                        color: AppColors.red,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: sizes.width,
                            margin: EdgeInsets.only(
                                left: 24, right: 24, top: 0, bottom: 24),
                            child: StreamBuilder(
                              stream: FirebaseFirestore.instance
                                  .collection('pets')
                                  .doc(_auth.currentUser?.uid)
                                  .collection('tasks')
                                  .where('date',
                                      isEqualTo:
                                          DateFormat('yMMMMd').format(_today))
                                  .snapshots(),
                              builder: (context,
                                  AsyncSnapshot<
                                          QuerySnapshot<Map<String, dynamic>>>
                                      snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          _buildTimeline(
                                              colorCollection[position]),
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
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    '${snapshot.data!.docs[position].data()['startTime']} - ${snapshot.data!.docs[position].data()['endTime']}',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 11,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                  SizedBox(
                                                    height: 8,
                                                  ),
                                                  Text(
                                                    '${snapshot.data!.docs[position].data()['title']},',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
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
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            decoration: BoxDecoration(
                                              color: colorCollection[position],
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                  separatorBuilder: (context, position) =>
                                      SizedBox(
                                    height: 12,
                                  ),
                                  itemCount: snapshot.data!.docs.length,
                                );
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                : Container(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 180,
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const PetProfileScreen(),
                                ),
                                (route) => false);
                          },
                          child: Container(
                            alignment: Alignment.topCenter,
                            child: Lottie.network(
                              'https://assets3.lottiefiles.com/packages/lf20_tf6wSv.json',
                            ),
                          ),
                        ),
                        Text(
                          'you don\'t have any pets, add new one',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
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
