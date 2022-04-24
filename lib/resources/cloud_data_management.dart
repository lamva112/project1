import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:intl/intl.dart';
import 'package:project1/resources/storage_methods.dart';
import 'package:project1/models/user.dart' as model;

class CloudStoreDataManagement {
  final _collectionName = 'users';
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<model.User> getUserDetails() async {
    User currentUser = _auth.currentUser!;

    DocumentSnapshot documentSnapshot =
        await _firestore.collection('users').doc(currentUser.uid).get();

    return model.User.fromSnap(documentSnapshot);
  }

  Future<bool> checkThisUserAlreadyPresentOrNot(
      {required String userName}) async {
    try {
      final QuerySnapshot<Map<String, dynamic>> findResults =
          await FirebaseFirestore.instance
              .collection(_collectionName)
              .where('userName', isEqualTo: userName)
              .get();

      print('Debug 1: ${findResults.docs.isEmpty}');

      return findResults.docs.isEmpty ? true : false;
    } catch (e) {
      print(
          'Error in Checkj This User Already Present or not: ${e.toString()}');
      return false;
    }
  }

  Future<bool> registerNewUser({
    required String userName,
    required String fullname,
    required Uint8List file,
    required String bio,
    required String phone,
    required String male,
    required String dateofbirth,
  }) async {
    try {
      final String? _getToken = await FirebaseMessaging.instance.getToken();

      final String currDate = DateFormat('dd-MM-yyyy').format(DateTime.now());

      final String currTime = "${DateFormat('hh:mm a').format(DateTime.now())}";

      String photoUrl = await StorageMethods()
          .uploadImageToStorage('profilePics', file, false);

      final String userEmail =
          FirebaseAuth.instance.currentUser!.email.toString();

      model.User _user = model.User(
        username: userName,
        uid: _auth.currentUser!.uid,
        photoUrl: photoUrl,
        email: userEmail,
        bio: bio,
        followers: [],
        following: [],
        creation_date: currDate,
        creation_time: currTime,
        phone: phone,
        token: _getToken.toString(),
        total_connections: [],
        connection_request: [],
        connections: {},
        activity: [],
        male: male,
        date_of_birth: dateofbirth,
      );

      await _firestore
          .collection("users")
          .doc(_auth.currentUser!.uid)
          .set(_user.toJson());

      return true;
    } catch (e) {
      print('Error in Register new user: ${e.toString()}');
      return false;
    }
  }

  Future<bool> userRecordPresentOrNot({required String email}) async {
    try {
      final DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
          await FirebaseFirestore.instance
              .doc('${this._collectionName}/$email')
              .get();
      return documentSnapshot.exists;
    } catch (e) {
      print('Error in user Record Present or not: ${e.toString()}');
      return false;
    }
  }
}
