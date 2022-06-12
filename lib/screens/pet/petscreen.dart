import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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

  @override
  void initState() {
    super.initState();
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
            backgroundColor: AppColors.white,
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
                ? Container(
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
                                margin:
                                    const EdgeInsets.only(left: 22, right: 22),
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
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      const SizedBox(
                                        height: 24,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 24),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  userData['name'],
                                                  style: GoogleFonts.quicksand(
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
                                                  style: GoogleFonts.quicksand(
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
                                            child: userData['gender'] == 'Male'
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
                      ],
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
}
