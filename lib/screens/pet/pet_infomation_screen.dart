import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project1/provider/pet_provider.dart';
import 'package:project1/screens/mainscreen/mainscreen.dart';
import 'package:project1/screens/pet/petscreen.dart';
import 'package:project1/utils/colors.dart';
import 'package:project1/utils/fonts.dart';
import 'package:project1/utils/loading_widget.dart';
import 'package:provider/provider.dart';

class PetInfomationScreen extends StatefulWidget {
  PetInfomationScreen({Key? key}) : super(key: key);

  @override
  State<PetInfomationScreen> createState() => _PetInfomationScreenState();
}

class _PetInfomationScreenState extends State<PetInfomationScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isLoading = false;
  var userData = {};
  @override
  void initState() {
    super.initState();
    getData();
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
        ? const Center(child: LoadingWidget())
        : Scaffold(
            body: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  Container(
                    width: sizes.width,
                    height: 153,
                    color: AppColors.red,
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Center(
                          child: Row(
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
                                    color: AppColors.white,
                                  ),
                                ),
                              ),
                              Text(
                                "Pet’s profile",
                                style: GoogleFonts.quicksand(
                                  textStyle: AppTextStyle.Title6,
                                ),
                              ),
                              SizedBox(
                                width: 0,
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          bottom: -80,
                          right: 24,
                          left: 24,
                          child: Container(
                            width: sizes.width,
                            height: 119,
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.grey1,
                                  blurRadius: 2.0,
                                  spreadRadius: 0.0,
                                  offset: Offset(
                                    0.0,
                                    0.0,
                                  ), // shadow direction: bottom right
                                )
                              ],
                            ),
                            child: Container(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 24, right: 24),
                                    child: Row(
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          child: Image.network(
                                            userData['petUrl'],
                                            width: 57,
                                            height: 57,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 12,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  "${userData['name'].toUpperCase()}",
                                                  style: GoogleFonts.quicksand(
                                                    textStyle:
                                                        AppTextStyle.Title2,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 2,
                                            ),
                                            Text(
                                              "${userData['breed']}",
                                              style: GoogleFonts.quicksand(
                                                textStyle: AppTextStyle.Body1,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          width: 80,
                                        ),
                                        userData['gender'] == 'Male'
                                            ? Icon(
                                                Icons.male,
                                                size: 32,
                                                color: AppColors.green,
                                              )
                                            : Icon(
                                                Icons.female,
                                                size: 32,
                                                color: AppColors.red,
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
                  ),
                  SizedBox(
                    height: 104,
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 24, right: 24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Pet’s infomation",
                          style: GoogleFonts.quicksand(
                            textStyle: AppTextStyle.Headline1,
                          ),
                        ),
                        Text(
                          "Edit",
                          style: GoogleFonts.quicksand(
                            textStyle: AppTextStyle.Body4,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Container(
                    width: sizes.width,
                    height: 268,
                    margin: EdgeInsets.only(left: 24, right: 24),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: AppColors.white,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.grey1,
                            blurRadius: 2.0,
                            spreadRadius: 0.0,
                            offset: Offset(
                              0.0,
                              0.0,
                            ),
                            // shadow direction: bottom right
                          )
                        ]),
                    child: Container(
                      width: sizes.width - 48,
                      height: 224,
                      margin: EdgeInsets.only(
                          left: 24, right: 24, top: 24, bottom: 24),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Name",
                                style: GoogleFonts.quicksand(
                                  textStyle: AppTextStyle.Headline5,
                                ),
                              ),
                              Text(
                                "${userData['name']}",
                                style: GoogleFonts.quicksand(
                                  textStyle: AppTextStyle.Headline1,
                                ),
                              ),
                            ],
                          ),
                          Divider(
                            thickness: 0.5,
                            color: AppColors.grey3,
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Breed",
                                style: GoogleFonts.quicksand(
                                  textStyle: AppTextStyle.Headline5,
                                ),
                              ),
                              Text(
                                "${userData['breed']}",
                                style: GoogleFonts.quicksand(
                                  textStyle: AppTextStyle.Headline1,
                                ),
                              ),
                            ],
                          ),
                          Divider(
                            thickness: 0.5,
                            color: AppColors.grey3,
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Gender",
                                style: GoogleFonts.quicksand(
                                  textStyle: AppTextStyle.Headline5,
                                ),
                              ),
                              Text(
                                "${userData['gender']}",
                                style: GoogleFonts.quicksand(
                                  textStyle: AppTextStyle.Headline1,
                                ),
                              ),
                            ],
                          ),
                          Divider(
                            thickness: 0.5,
                            color: AppColors.grey3,
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Colors",
                                style: GoogleFonts.quicksand(
                                  textStyle: AppTextStyle.Headline5,
                                ),
                              ),
                              Text(
                                "${userData['color']}",
                                style: GoogleFonts.quicksand(
                                  textStyle: AppTextStyle.Headline1,
                                ),
                              ),
                            ],
                          ),
                          Divider(
                            thickness: 0.5,
                            color: AppColors.grey3,
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Birthday",
                                style: GoogleFonts.quicksand(
                                  textStyle: AppTextStyle.Headline5,
                                ),
                              ),
                              Text(
                                "${userData['dateofbrith']}",
                                style: GoogleFonts.quicksand(
                                  textStyle: AppTextStyle.Headline1,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 32,
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 24, right: 24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Vaccination Information",
                          style: GoogleFonts.quicksand(
                            textStyle: AppTextStyle.Headline1,
                          ),
                        ),
                        Text(
                          "Edit",
                          style: GoogleFonts.quicksand(
                            textStyle: AppTextStyle.Body4,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Container(
                    width: sizes.width,
                    margin: EdgeInsets.only(left: 24, right: 24),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: AppColors.white,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.grey1,
                            blurRadius: 2.0,
                            spreadRadius: 0.0,
                            offset: Offset(
                              0.0,
                              0.0,
                            ),
                            // shadow direction: bottom right
                          )
                        ]),
                    child: Container(
                      width: sizes.width - 48,
                      margin: EdgeInsets.only(
                          left: 24, right: 24, top: 0, bottom: 24),
                      child: StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('pets')
                            .doc(_auth.currentUser!.uid)
                            .collection('vaccines')
                            .snapshots(),
                        builder: (context,
                            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
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
                              return Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    ' ${snapshot.data!.docs[position].data()['nameVacine']}',
                                    style: GoogleFonts.quicksand(
                                      textStyle: AppTextStyle.Body2,
                                      color: AppColors.black,
                                    ),
                                  ),
                                  Text(
                                    "${snapshot.data!.docs[position].data()['status']}",
                                    style: GoogleFonts.quicksand(
                                      textStyle: AppTextStyle.Body2,
                                      color: snapshot.data!.docs[position]
                                                  .data()['status'] ==
                                              'completed'
                                          ? AppColors.green
                                          : AppColors.red,
                                    ),
                                  ),
                                ],
                              );
                            },
                            separatorBuilder: (context, position) => Container(
                              child: Divider(
                                height: 32,
                                thickness: 0.5,
                                color: AppColors.grey3,
                              ),
                            ),
                            itemCount: snapshot.data!.docs.length,
                          );
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 32,
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 24, right: 24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Medical History",
                          style: GoogleFonts.quicksand(
                            textStyle: AppTextStyle.Headline1,
                          ),
                        ),
                        Text(
                          "Edit",
                          style: GoogleFonts.quicksand(
                            textStyle: AppTextStyle.Body4,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Container(
                    width: sizes.width,
                    margin: EdgeInsets.only(left: 24, right: 24),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: AppColors.white,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.grey1,
                            blurRadius: 2.0,
                            spreadRadius: 0.0,
                            offset: Offset(
                              0.0,
                              0.0,
                            ),
                            // shadow direction: bottom right
                          )
                        ]),
                    child: Container(
                      width: sizes.width - 48,
                      margin: EdgeInsets.only(
                          left: 24, right: 24, top: 0, bottom: 24),
                      child: StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('pets')
                            .doc(_auth.currentUser!.uid)
                            .collection('diseases')
                            .snapshots(),
                        builder: (context,
                            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
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
                              return Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    ' ${snapshot.data!.docs[position].data()['nameDiseases']}',
                                    style: GoogleFonts.quicksand(
                                      textStyle: AppTextStyle.Body2,
                                      color: AppColors.black,
                                    ),
                                  ),
                                  Text(
                                    "${snapshot.data!.docs[position].data()['status']}",
                                    style: GoogleFonts.quicksand(
                                      textStyle: AppTextStyle.Body2,
                                      color: snapshot.data!.docs[position]
                                                  .data()['status'] ==
                                              'completed'
                                          ? AppColors.green
                                          : AppColors.red,
                                    ),
                                  ),
                                ],
                              );
                            },
                            separatorBuilder: (context, position) => Container(
                              child: Divider(
                                height: 32,
                                thickness: 0.5,
                                color: AppColors.grey3,
                              ),
                            ),
                            itemCount: snapshot.data!.docs.length,
                          );
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                ],
              ),
            ),
          );
  }
}
