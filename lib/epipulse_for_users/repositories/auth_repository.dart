import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:epipulse/utils/shortcuts.dart';

import 'package:epipulse/epipulse_for_users/Screens/login_screen.dart';
import 'package:epipulse/epipulse_for_users/Screens/main_entry_screen.dart';
import 'package:epipulse/epipulse_for_users/Screens/otp_screen.dart';
import 'package:epipulse/epipulse_for_users/Screens/user_info_screen.dart';
import 'package:epipulse/models/user_model.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

final FirebaseAuth auth = FirebaseAuth.instance;
String verificationid = '';
Userinfo? currentUser;

void sendPhoneNumber(String phonenumber, BuildContext context) async {
  print('Bypassing phone verification.');
  // Directly navigate to OTP or main screen if needed
  finishLogin(context);
}

void verifyOTP(String userOTP, BuildContext context) async {
  print('Bypassing OTP verification.');
  // Directly navigate to main screen if needed
  finishLogin(context);
}

Future<Userinfo?> getCurrentUserData() async {
  var data = await FirebaseFirestore.instance
      .collection('users')
      .doc(auth.currentUser?.uid)
      .get();
  if (data.data() != null) {
    currentUser = Userinfo.fromMap(data.data()!);
  }
  return currentUser;
}

void finishLogin(BuildContext context) async {
  var userData = await FirebaseFirestore.instance
      .collection('users')
      .doc(auth.currentUser?.uid)
      .get();
  if (userData.data() != null) {
    if (context.mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const UserMainScreen()),
        (route) => false,
      );
    }
  } else {
    if (context.mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const UserInfoScreen()),
        (route) => false,
      );
    }
  }
}

void saveUserData(Userinfo user) {
  FirebaseFirestore.instance
      .collection('users')
      .doc(auth.currentUser!.uid)
      .set(user.toMap());
}

void signOut(BuildContext context) {
  auth.signOut();
  Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreenUser()),
      (route) => false);
}
