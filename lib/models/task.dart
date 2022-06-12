import 'package:cloud_firestore/cloud_firestore.dart';

class Date {
  String date;
  String title;
  String des;
  bool remind;
  String startTime;
  String endTime;
  int startHour;
  Date({
    required this.date,
    required this.title,
    required this.des,
    required this.remind,
    required this.startTime,
    required this.endTime,
    required this.startHour,
  });

  static Date fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Date(
      date: snapshot['date'],
      title: snapshot['title'],
      des: snapshot['des'],
      remind: snapshot['remind'],
      startTime: snapshot['startTime'],
      endTime: snapshot['endTime'],
      startHour: snapshot['startHour'],
    );
  }

  Map<String, dynamic> toJson() => {
        "date": date,
        "title": title,
        "des": des,
        "remind": remind,
        "startTime": startTime,
        "endTime": endTime,
        'startHour': startHour,
      };
}
