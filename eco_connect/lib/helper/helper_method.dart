// reutrn a formatted date as a string
import 'package:cloud_firestore/cloud_firestore.dart';

String formatDate(Timestamp timestamp){
  // Timestamp is the object we retrieve from firebase
  // to display it, it is converted to a string
  DateTime dateTime = timestamp.toDate();

  // get the year
  String year = dateTime.year.toString();
  // get the month
  String month= dateTime.month.toString();
  // get the day
  String day= dateTime.day.toString();

  // final date string
  String formattedDate = '$day/$month/$year';
  return formattedDate;
}
