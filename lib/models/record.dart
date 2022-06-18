import 'package:cloud_firestore/cloud_firestore.dart';

class Record {
  String date;
  String temp;
  String weight;
  String fat;
  String neck;
  String waist;
  String height;
  String width;
  String note;
  String meal;
  String uid;
  Record(
      {required this.date,
      required this.temp,
      required this.weight,
      required this.fat,
      required this.neck,
      required this.waist,
      required this.height,
      required this.width,
      required this.note,
      required this.meal,
      required this.uid});

  static Record fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Record(
      date: snapshot["date"],
      temp: snapshot["temp"],
      weight: snapshot["weight"],
      fat: snapshot["fat"],
      neck: snapshot["neck"],
      waist: snapshot["waist"],
      height: snapshot["height"],
      width: snapshot["width"],
      meal: snapshot["meal"],
      note: snapshot["note"],
      uid: snapshot["uid"],
    );
  }

  Map<String, dynamic> toJson() => {
        "date": date,
        "temp": temp,
        "weight": weight,
        "fat": fat,
        "neck": neck,
        "waist": waist,
        "height": height,
        "width": width,
        "meal": meal,
        "note": note,
        'uid': uid,
      };
}
