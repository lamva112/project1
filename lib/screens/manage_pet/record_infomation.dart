import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project1/screens/manage_pet/add_blood_pressure.dart';
import 'package:project1/screens/manage_pet/add_spending_sreen.dart';
import 'package:project1/utils/fonts.dart';

import '../../utils/colors.dart';

class recordInfomation extends StatefulWidget {
  final snap;
  recordInfomation({Key? key, this.snap}) : super(key: key);

  @override
  State<recordInfomation> createState() => _recordInfomationState();
}

class _recordInfomationState extends State<recordInfomation> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.red,
        title: Text(
          '${widget.snap['date']}',
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 18,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  width: 8,
                ),
                Text(
                  "record of the day",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.red,
                  ),
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.only(left: 8, right: 8),
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
                      "temp : ${widget.snap['temp']} * C",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
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
                      "weight : ${widget.snap['weight']} Kg",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
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
                      "fat body : ${widget.snap['fat']}%",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 18, right: 18),
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
              margin: EdgeInsets.only(left: 8, right: 8),
              child: Divider(
                thickness: 0.5,
                color: AppColors.grey3,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                SizedBox(
                  width: 8,
                ),
                Text(
                  "Meal",
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                ),
              ],
            ),
            SizedBox(
              height: 8,
            ),
            Row(
              children: [
                SizedBox(
                  width: 8,
                ),
                Text(
                  "${widget.snap['meal']}",
                  style: TextStyle(color: Colors.black, fontSize: 16),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                SizedBox(
                  width: 8,
                ),
                Text(
                  "Take medicines",
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                ),
              ],
            ),
            SizedBox(
              height: 8,
            ),
            Row(
              children: [
                SizedBox(
                  width: 8,
                ),
                Text(
                  "${widget.snap['waist']}",
                  style: TextStyle(color: Colors.black, fontSize: 16),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                SizedBox(
                  width: 8,
                ),
                Text(
                  "medical treatment",
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                ),
              ],
            ),
            SizedBox(
              height: 8,
            ),
            Row(
              children: [
                SizedBox(
                  width: 8,
                ),
                Text(
                  "${widget.snap['neck']}",
                  style: TextStyle(color: Colors.black, fontSize: 16),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                SizedBox(
                  width: 8,
                ),
                Text(
                  "note",
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                ),
              ],
            ),
            SizedBox(
              height: 8,
            ),
            Row(
              children: [
                SizedBox(
                  width: 8,
                ),
                Text(
                  "${widget.snap['note']}",
                  style: TextStyle(color: Colors.black, fontSize: 16),
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.only(left: 8, right: 8),
              child: Divider(
                thickness: 0.5,
                color: AppColors.grey3,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                SizedBox(
                  width: 8,
                ),
                Text(
                  "blood pressure",
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                ),
              ],
            ),
            SizedBox(
              height: 8,
            ),
            Container(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('records')
                    .doc(_auth.currentUser!.uid)
                    .collection('blood')
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
                        margin: const EdgeInsets.only(left: 8, right: 8),
                        width: size.width,
                        height: 56,
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: const [
                            BoxShadow(
                              color: AppColors.grey1,
                              blurRadius: 1.0,
                              spreadRadius: 0.0,
                              offset: Offset(
                                0.0,
                                0.0,
                              ), // shadow direction: bottom right
                            )
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 8),
                              child: Text(
                                '${snapshot.data!.docs[position].data()['blood_pressure']}/${snapshot.data!.docs[position].data()['d_blood_pressure']} mmhg * ${snapshot.data!.docs[position].data()['d_blood_pressure']} bpm',
                                style: GoogleFonts.quicksand(
                                  textStyle: AppTextStyle.Body2,
                                  color: AppColors.black,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 23),
                              child: Text(
                                "${snapshot.data!.docs[position].data()['datePublished']}",
                                style: GoogleFonts.quicksand(
                                    textStyle: AppTextStyle.Body2,
                                    color: AppColors.green),
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
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => AddBloodPressure(),
                  ),
                );
              },
              child: Row(
                children: [
                  const SizedBox(
                    width: 8,
                  ),
                  SvgPicture.asset(
                    'assets/icons/addd.svg',
                    color: AppColors.black,
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Text(
                    "Add new vaccination",
                    style: GoogleFonts.quicksand(
                      textStyle: AppTextStyle.Body2,
                      color: AppColors.black,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                SizedBox(
                  width: 8,
                ),
                Text(
                  "spending",
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                ),
              ],
            ),
            SizedBox(
              height: 8,
            ),
            Container(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('records')
                    .doc(_auth.currentUser!.uid)
                    .collection('pending')
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
                        margin: const EdgeInsets.only(left: 8, right: 8),
                        width: size.width,
                        height: 56,
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: const [
                            BoxShadow(
                              color: AppColors.grey1,
                              blurRadius: 1.0,
                              spreadRadius: 0.0,
                              offset: Offset(
                                0.0,
                                0.0,
                              ), // shadow direction: bottom right
                            )
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 8),
                              child: Text(
                                ' ${snapshot.data!.docs[position].data()['note']}',
                                style: GoogleFonts.quicksand(
                                  textStyle: AppTextStyle.Body2,
                                  color: AppColors.black,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 23),
                              child: Text(
                                "-${snapshot.data!.docs[position].data()['money']}",
                                style: GoogleFonts.quicksand(
                                  textStyle: AppTextStyle.Body2,
                                  color: AppColors.red,
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
              onTap: (() {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => AddPendingSreen(),
                  ),
                );
              }),
              child: Row(
                children: [
                  const SizedBox(
                    width: 8,
                  ),
                  SvgPicture.asset(
                    'assets/icons/addd.svg',
                    color: AppColors.black,
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Text(
                    "Add new vaccination",
                    style: GoogleFonts.quicksand(
                      textStyle: AppTextStyle.Body2,
                      color: AppColors.black,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 85,
            ),
          ],
        ),
      ),
    );
  }
}
