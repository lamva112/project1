import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:project1/resources/storage_methods.dart';
import 'package:project1/models/user.dart' as model;
import 'package:project1/utils/constants.dart';
import 'package:project1/utils/enum_generation.dart';

import '../models/pet.dart' as models;
import '../models/task.dart';
import '../utils/send_notification_management.dart';

class CloudStoreDataManagement {
  final _collectionName = 'users';
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final SendNotification _sendNotification = SendNotification();

  Future<model.User> getUserDetails() async {
    User currentUser = _auth.currentUser!;

    DocumentSnapshot documentSnapshot = await _firestore
        .collection('users')
        .doc(currentUser.email.toString())
        .get();

    return model.User.fromSnap(documentSnapshot);
  }

  Future<models.Pet> getPetDetails() async {
    DocumentSnapshot documentSnapshot =
        await _firestore.collection('pets').doc(_auth.currentUser!.uid).get();

    return models.Pet.fromSnap(documentSnapshot);
  }

  Future<bool> checkThisUser({required String userName}) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .where('username', isEqualTo: userName)
          .get()
          .then((value) => value.size > 0 ? true : false);
    } catch (e) {
      debugPrint(e.toString());
    }
    return false;
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

      final String currTime = DateFormat('hh:mm a').format(DateTime.now());

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

      await _firestore.collection("users").doc(userEmail).set(_user.toJson());

      return true;
    } catch (e) {
      print('Error in Register new user: ${e.toString()}');
      return false;
    }
  }

  Future<String> AddTask(
      {required String des,
      required String title,
      required String dates,
      required String startTime,
      required String endTime,
      required bool remind,
      required int startHour}) async {
    // asking uid here because we dont want to make extra calls to firebase auth when we can just get from our state management
    String res = "Some error occurred";
    try {
      // creates unique id based on time

      Date date = Date(
        date: dates,
        title: title,
        des: des,
        remind: remind,
        startTime: startTime,
        startHour: startHour,
        endTime: endTime,
      );
      _firestore
          .collection('pets')
          .doc(_auth.currentUser!.uid)
          .collection('tasks')
          .doc(dates)
          .set(date.toJson());
      res = "success";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<bool> userRecordPresentOrNot({required String uid}) async {
    try {
      final DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
          await FirebaseFirestore.instance
              .collection(_collectionName)
              .doc(uid)
              .get();
      return documentSnapshot.exists;
    } catch (e) {
      print('Error in user Record Present or not: ${e.toString()}');
      return false;
    }
  }

  Future<bool> registerNewPet({
    required String name,
    required String breed,
    required String gender,
    required String color,
    required String dateofbrith,
    required Uint8List file,
  }) async {
    try {
      final String userEmail =
          FirebaseAuth.instance.currentUser!.email.toString();

      String photoUrl =
          await StorageMethods().uploadImageToStorage('petsPics', file, true);

      models.Pet pet = models.Pet(
        name: name,
        uid: _auth.currentUser!.uid,
        breed: breed,
        gender: gender,
        color: color,
        dateofbrith: dateofbrith,
        petUrl: photoUrl,
      );
      _firestore
          .collection('pets')
          .doc(_auth.currentUser!.uid)
          .set(pet.toJson());
      return true;
    } catch (err) {
      print('Error in Register new user: ${err.toString()}');
      return false;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<bool> addVacine({
    required String petName,
    required String VccName,
    required String status,
  }) async {
    String res = "Some error occurred";
    try {
      // if the likes list contains the user uid, we need to remove it

      _firestore
          .collection('pets')
          .doc(_auth.currentUser!.uid)
          .collection('vaccines')
          .doc(VccName)
          .set({
        'nameVacine': VccName,
        'uid': _auth.currentUser!.uid,
        'status': status,
        'datePublished': DateTime.now(),
      });
      return true;
    } catch (err) {
      print('Error in Register new user: ${err.toString()}');
      return false;
    }
  }

  Future<bool> Diseases({
    required String petName,
    required String DisName,
    required String status,
  }) async {
    String res = "Some error occurred";
    try {
      // if the likes list contains the user uid, we need to remove it

      _firestore
          .collection('pets')
          .doc(_auth.currentUser!.uid)
          .collection('diseases')
          .doc(DisName)
          .set({
        'nameDiseases': DisName,
        'uid': _auth.currentUser!.uid,
        'status': status,
        'datePublished': DateTime.now(),
      });
      return true;
    } catch (err) {
      print('Error in Register new user: ${err.toString()}');
      return false;
    }
  }

  Future<bool> petPresentOrNot({required String uid}) async {
    try {
      final DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
          await FirebaseFirestore.instance.collection('pets').doc(uid).get();
      return documentSnapshot.exists;
    } catch (e) {
      print('Error in user Record Present or not: ${e.toString()}');
      return false;
    }
  }

  Future<bool> Task({
    required String petName,
    required String DisName,
    required String status,
  }) async {
    String res = "Some error occurred";
    try {
      // if the likes list contains the user uid, we need to remove it

      _firestore
          .collection('pets')
          .doc(_auth.currentUser!.uid)
          .collection('diseases')
          .doc(DisName)
          .set({
        'nameDiseases': DisName,
        'uid': _auth.currentUser!.uid,
        'status': status,
        'datePublished': DateTime.now(),
      });
      return true;
    } catch (err) {
      print('Error in Register new user: ${err.toString()}');
      return false;
    }
  }

  Future<Map<String, dynamic>> getTokenFromCloudStore(
      {required String userMail}) async {
    try {
      final DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
          await FirebaseFirestore.instance
              .doc('${this._collectionName}/$userMail')
              .get();

      print('DocumentSnapShot is: ${documentSnapshot.data()}');

      final Map<String, dynamic> importantData = Map<String, dynamic>();

      importantData["token"] = documentSnapshot.data()!["token"];
      importantData["date"] = documentSnapshot.data()!["creation_date"];
      importantData["time"] = documentSnapshot.data()!["creation_time"];

      return importantData;
    } catch (e) {
      print('Error in get Token from Cloud Store: ${e.toString()}');
      return {};
    }
  }

  Future<List<Map<String, dynamic>>> getAllUsersListExceptMyAccount(
      {required String currentUserEmail}) async {
    try {
      final QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance
              .collection(this._collectionName)
              .get();

      List<Map<String, dynamic>> _usersDataCollection = [];

      querySnapshot.docs.forEach(
          (QueryDocumentSnapshot<Map<String, dynamic>> queryDocumentSnapshot) {
        if (currentUserEmail != queryDocumentSnapshot.id)
          _usersDataCollection.add({
            queryDocumentSnapshot.id:
                '${queryDocumentSnapshot.get("user_name")}[user-name-about-divider]${queryDocumentSnapshot.get("about")}',
          });
      });

      print(_usersDataCollection);

      return _usersDataCollection;
    } catch (e) {
      print('Error in get All Users List: ${e.toString()}');
      return [];
    }
  }

  Future<Map<String, dynamic>?> _getCurrentAccountAllData(
      {required String email}) async {
    try {
      final DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
          await FirebaseFirestore.instance
              .doc('${this._collectionName}/$email')
              .get();

      return documentSnapshot.data();
    } catch (e) {
      print('Error in getCurrentAccountAll Data: ${e.toString()}');
      return {};
    }
  }

  Future<List<dynamic>> currentUserConnectionRequestList(
      {required String email}) async {
    try {
      Map<String, dynamic>? _currentUserData =
          await _getCurrentAccountAllData(email: email);

      final List<dynamic> _connectionRequestCollection =
          _currentUserData!["connection_request"];

      print('Collection: $_connectionRequestCollection');

      return _connectionRequestCollection;
    } catch (e) {
      print('Error in Current USer Collection List: ${e.toString()}');
      return [];
    }
  }

  Future<void> changeConnectionStatus({
    required String oppositeUserMail,
    required String currentUserMail,
    required String connectionUpdatedStatus,
    required List<dynamic> currentUserUpdatedConnectionRequest,
    bool storeDataAlsoInConnections = false,
  }) async {
    try {
      print('Come here');

      /// Opposite Connection database Update
      final DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
          await FirebaseFirestore.instance
              .doc('${this._collectionName}/$oppositeUserMail')
              .get();

      Map<String, dynamic>? map = documentSnapshot.data();

      print('Map: $map');

      List<dynamic> _oppositeConnectionsRequestsList =
          map!["connection_request"];

      int index = -1;

      _oppositeConnectionsRequestsList.forEach((element) {
        if (element.keys.first.toString() == currentUserMail)
          index = _oppositeConnectionsRequestsList.indexOf(element);
      });

      if (index > -1) _oppositeConnectionsRequestsList.removeAt(index);

      print('Opposite Connections: $_oppositeConnectionsRequestsList');

      _oppositeConnectionsRequestsList.add({
        currentUserMail: connectionUpdatedStatus,
      });

      print('Opposite Connections: $_oppositeConnectionsRequestsList');

      map["connection_request"] = _oppositeConnectionsRequestsList;

      if (storeDataAlsoInConnections)
        map[FirestoreFieldConstants().connections].addAll({
          currentUserMail: [],
        });

      await FirebaseFirestore.instance
          .doc('${this._collectionName}/$oppositeUserMail')
          .update(map);

      /// Current User Connection Database Update
      final Map<String, dynamic>? currentUserMap =
          await _getCurrentAccountAllData(email: currentUserMail);

      currentUserMap!["connection_request"] =
          currentUserUpdatedConnectionRequest;

      if (storeDataAlsoInConnections)
        currentUserMap[FirestoreFieldConstants().connections].addAll({
          oppositeUserMail: [],
        });

      await FirebaseFirestore.instance
          .doc('${this._collectionName}/$currentUserMail')
          .update(currentUserMap);
    } catch (e) {
      print('Error in Change Connection Status: ${e.toString()}');
    }
  }

  Future<Stream<QuerySnapshot<Map<String, dynamic>>>?>
      fetchRealTimeDataFromFirestore() async {
    try {
      return FirebaseFirestore.instance
          .collection(this._collectionName)
          .snapshots();
    } catch (e) {
      print('Error in Fetch Real Time Data : ${e.toString()}');
      return null;
    }
  }

  Future<Stream<DocumentSnapshot<Map<String, dynamic>>>?>
      fetchRealTimeMessages() async {
    try {
      return FirebaseFirestore.instance
          .doc(
              '${this._collectionName}/${FirebaseAuth.instance.currentUser!.email.toString()}')
          .snapshots();
    } catch (e) {
      print('Error in Fetch Real Time Data : ${e.toString()}');
      return null;
    }
  }
}
