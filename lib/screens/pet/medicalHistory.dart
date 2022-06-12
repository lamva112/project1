import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project1/screens/mainscreen/mainscreen.dart';
import 'package:project1/screens/pet/addMedicalHistory.dart';
import 'package:project1/utils/colors.dart';
import 'package:project1/utils/fonts.dart';

class MedicalHistoryScreen extends StatefulWidget {
  final String petname;
  const MedicalHistoryScreen({Key? key, required this.petname}) : super(key: key);

  @override
  State<MedicalHistoryScreen> createState() => _MedicalHistoryScreenState();
}

class _MedicalHistoryScreenState extends State<MedicalHistoryScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppColors.grey6,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(
            height: 40,
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
                width: 65,
              ),
              Text(
                "Medical History",
                style: GoogleFonts.quicksand(
                  textStyle: AppTextStyle.Title2,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 16,
          ),
          Container(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('pets')
                  .doc(_auth.currentUser!.uid)
                  .collection('diseases')
                  .snapshots(),
              builder: (context,
                  AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                return ListView.separated(
                  shrinkWrap: true,
                  itemBuilder: (context, position) {
                    return Container(
                      margin: const EdgeInsets.only(left: 28, right: 28),
                      width: size.width,
                      height: 56,
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 23),
                            child: Text(
                              ' ${snapshot.data!.docs[position].data()['nameDiseases']}',
                              style: GoogleFonts.quicksand(
                                textStyle: AppTextStyle.Body2,
                                color: AppColors.black,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 23),
                            child: Text(
                              "${snapshot.data!.docs[position].data()['status']}",
                              style: GoogleFonts.quicksand(
                                textStyle: AppTextStyle.Body2,
                                color: snapshot.data!.docs[position]
                                            .data()['status'] ==
                                        'Recover'
                                    ? AppColors.green
                                    : AppColors.yellow,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  separatorBuilder: (context, position) => const SizedBox(
                    height: 10,
                  ),
                  itemCount: snapshot.data!.docs.length,
                );
              },
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          InkWell(
            onTap: (() => Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (_) => AddMedicalHistoryScreen(
                    petname: widget.petname,
                  ),
                ),
                (route) => false)),
            child: Row(
              children: [
                const SizedBox(
                  width: 24,
                ),
                SvgPicture.asset(
                  'assets/icons/addd.svg',
                  color: AppColors.black,
                ),
                const SizedBox(
                  width: 8,
                ),
                Text(
                  "Add new medical history! ",
                  style: GoogleFonts.quicksand(
                    textStyle: AppTextStyle.Body2,
                    color: AppColors.black,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomSheet: signUpAuthButton(context, 'save'),
    );
  }

  Widget signUpAuthButton(BuildContext context, String buttonName) {
    return Padding(
      padding: const EdgeInsets.only(left: 24.0, right: 24.0, bottom: 24),
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
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (_) => const MainScreen(),
              ),
              (route) => false);
        },
      ),
    );
  }
}
