import 'package:cloud_firestore/cloud_firestore.dart';

class Pet {
  final String name;
  final String breed;
  final String gender;
  final String color;
  final String dateofbrith;
  final String petUrl;
  final String uid;

  const Pet({
    required this.name,
    required this.breed,
    required this.gender,
    required this.color,
    required this.dateofbrith,
    required this.petUrl,
    required this.uid,
  });

  static Pet fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Pet(
      name: snapshot["name"],
      breed: snapshot["breed"],
      gender: snapshot["gender"],
      color: snapshot["color"],
      dateofbrith: snapshot["dateofbrith"],
      petUrl: snapshot["petUrl"],
      uid: snapshot["uid"],
    );
  }

  Map<String, dynamic> toJson() => {
        "name": name,
        "breed": breed,
        "gender": gender,
        "color": color,
        "dateofbrith": dateofbrith,
        "petUrl": petUrl,
        'uid': uid,
      };
}
