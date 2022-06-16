import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:project1/chat/ChatRoom.dart';
import 'package:project1/provider/user_provider.dart';
import 'package:project1/utils/colors.dart';
import 'package:project1/utils/fonts.dart';
import 'package:provider/provider.dart';

import '../models/user.dart' as models;
import '../utils/colors.dart';

class messsageScreen extends StatefulWidget {
  String uid;
  messsageScreen({Key? key, required this.uid}) : super(key: key);

  @override
  State<messsageScreen> createState() => _messsageScreenState();
}

class _messsageScreenState extends State<messsageScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  List<models.User> userList = [];

  String chatRoomId(String user1, String user2) {
    if (user1.compareTo(user2) == -1) {
      return "$user1$user2";
    } else {
      return "$user2$user1";
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final UserProvider userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      body: Container(
        child: Column(children: [
          Container(
            width: 367,
            height: 48,
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .where('uid', isNotEqualTo: userProvider.getUser.uid)
                  .snapshots(),
              builder: (context,
                  AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return ListView.separated(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemBuilder: (context, position) {
                    return Container(
                      padding: EdgeInsets.only(left: 4, right: 4),
                      alignment: Alignment.center,
                      child: GestureDetector(
                        onTap: () {
                          String roomId = '';
                          roomId = chatRoomId(
                            userProvider.getUser.username,
                            snapshot.data!.docs[position].data()['username'],
                          );
                          if (roomId != '') {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => ChatRoom(
                                  snap: snapshot.data!.docs[position].data(),
                                  messagesId: roomId,
                                ),
                              ),
                            );
                          }

                          print("$roomId");
                        },
                        child: AnimatedContainer(
                          alignment: Alignment.center,
                          duration: Duration(milliseconds: 300),
                          height: 48,
                          width: 48,
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: Container(
                            alignment: Alignment.bottomCenter,
                            width: 48,
                            height: 48,
                            child: Container(
                              padding: EdgeInsets.all(4),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: Image.network(
                                  snapshot.data!.docs[position]
                                      .data()['photoUrl'],
                                  width: 32,
                                  height: 32,
                                ),
                              ),
                            ),
                            decoration: new BoxDecoration(
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
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
        ]),
      ),
    );
  }
}
