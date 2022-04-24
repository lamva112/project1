import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String email;
  final String uid;
  final String photoUrl;
  final String username;
  final String bio;
  final List followers;
  final List following;
  final String phone;
  final String creation_date;
  final String creation_time;
  final String token;
  final List total_connections;
  final List activity;
  final List connection_request;
  final Map connections;
  final String date_of_birth;
  final String male;
  const User({
    required this.username,
    required this.uid,
    required this.photoUrl,
    required this.email,
    required this.bio,
    required this.followers,
    required this.following,
    required this.creation_date,
    required this.creation_time,
    required this.phone,
    required this.token,
    required this.total_connections,
    required this.activity,
    required this.connection_request,
    required this.connections,
    required this.date_of_birth,
    required this.male,
  });

  static User fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return User(
      username: snapshot["username"],
      uid: snapshot["uid"],
      email: snapshot["email"],
      photoUrl: snapshot["photoUrl"],
      bio: snapshot["bio"],
      followers: snapshot["followers"],
      following: snapshot["following"],
      creation_date: snapshot["creation_date"],
      creation_time: snapshot["creation_time"],
      phone: snapshot["phone"],
      token: snapshot["token"],
      total_connections: snapshot["total_connections"],
      activity: snapshot["activity"],
      connection_request: snapshot["connection_request"],
      connections: snapshot["connections"],
      date_of_birth: snapshot["date_of_birth"],
      male: snapshot["male"],
    );
  }

  Map<String, dynamic> toJson() => {
        "username": username,
        "activity": [],
        "connection_request": [],
        "connections": {},
        "uid": uid,
        "email": email,
        "photoUrl": photoUrl,
        "bio": bio,
        "followers": followers,
        "following": following,
        "creation_date": creation_date,
        "creation_time": creation_time,
        "Phone": phone,
        "token": token,
        "total_connections": [],
        "date_of_birth": date_of_birth,
        "male": male,
      };
}
