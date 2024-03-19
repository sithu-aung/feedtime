import 'package:flutter/material.dart';

const greenDarkColor = Color.fromARGB(255, 66, 95, 61);
const greenWhiteColor = Color.fromARGB(255, 237, 245, 236);
const greenPaleColor = Color.fromARGB(255, 196, 245, 197);
const greenMediumColor = Color.fromARGB(255, 150, 231, 152);
const greenNormalColor = Color.fromARGB(255, 70, 202, 74);

List<String> items = [
  "Every 1 mins",
  "Every 2 mins",
  "Every 5 mins",
  "Every 10 mins"
];
List<int> reminderMins = [1, 2, 5, 10];

extension Gap on num {
  SizedBox get vGap => SizedBox(height: toDouble());
  SizedBox get hGap => SizedBox(width: toDouble());
}
