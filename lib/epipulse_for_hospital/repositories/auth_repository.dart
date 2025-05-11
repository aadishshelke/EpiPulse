import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:epipulse/models/hospital_model.dart';
import 'package:epipulse/epipulse_for_hospital/Screens/hospital_info_screen.dart';
import 'package:epipulse/epipulse_for_hospital/Screens/login_screen_hospital.dart';
import 'package:epipulse/epipulse_for_hospital/Screens/hospital_main_screen.dart';
import 'package:epipulse/epipulse_for_hospital/Screens/otp_screen.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:epipulse/utils/shortcuts.dart';

final FirebaseAuth auth = FirebaseAuth.instance;
String verificationid = '';
Hospitalinfo? currentHospital;

void sendPhoneNumberHospital(String phonenumber, BuildContext context) async {
  print('Bypassing phone verification.');
  finishLoginHospital(context);
}

void verifyOTPHospital(String userOTP, BuildContext context) async {
  print('Bypassing OTP verification.');
  finishLoginHospital(context);
}

void finishLoginHospital(BuildContext context) async {
  var userData = await FirebaseFirestore.instance
      .collection('hospitals')
      .doc(auth.currentUser?.uid)
      .get();
  if (userData.data() != null) {
    if (context.mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const HospitalMainScreen()),
        ((route) => false),
      );
    }
  } else {
    if (context.mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const HospitalInfoScreen()),
        ((route) => false),
      );
    }
  }
}

void saveHospitalData(Hospitalinfo hospital) {
  FirebaseFirestore.instance
      .collection('hospitals')
      .doc(auth.currentUser!.uid)
      .set(hospital.toMap());
}

Future<Hospitalinfo?> getCurrentHospitalData() async {
  var data = await FirebaseFirestore.instance
      .collection('hospitals')
      .doc(auth.currentUser?.uid)
      .get();
  if (data.data() != null) {
    currentHospital = Hospitalinfo.fromMap(data.data()!);
  }
  return currentHospital;
}

void signOutHospital(BuildContext context) {
  auth.signOut();
  Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreenHospital()),
      (route) => false);
}
