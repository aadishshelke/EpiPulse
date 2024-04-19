import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emedoc/models/hospital_model.dart';
import 'package:emedoc/emedoc_for_hospital/Screens/hospital_info_screen.dart';
import 'package:emedoc/emedoc_for_hospital/Screens/login_screen_hospital.dart';
import 'package:emedoc/emedoc_for_hospital/Screens/hospital_main_screen.dart';
import 'package:emedoc/emedoc_for_hospital/Screens/otp_screen.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:emedoc/utils/shortcuts.dart';

final FirebaseAuth auth = FirebaseAuth.instance;
String verificationid = '';
Hospitalinfo? currentHospital;

void sendPhoneNumberHospital(String phonenumber, BuildContext context) async {
  print(phonenumber);
  await auth.verifyPhoneNumber(
    phoneNumber: phonenumber,
    verificationCompleted: (PhoneAuthCredential credential) async {
      // ANDROID ONLY!

      // Sign the user in (or link) with the auto-generated credential
      await auth.signInWithCredential(credential);
    },
    verificationFailed: (FirebaseAuthException e) {
      if (e.code == 'invalid-phone-number') {
        print('The provided phone number is not valid.');
      }

      // Handle other errors
    },
    codeSent: (String verificationId, int? resendToken) async {
      verificationid = verificationId;
      // Update the UI - wait for the user to enter the SMS code
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const OTPScreen()));

      // Sign the user in (or link) with the credential
    },
    codeAutoRetrievalTimeout: (String verificationId) {
      // Auto-resolution timed out...
    },
  );
}

void verifyOTPHospital(String userOTP, BuildContext context) async {
  try {
    // Create a PhoneAuthCredential with the code
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationid, smsCode: userOTP);

    // Sign the user in (or link) with the credential
    await auth.signInWithCredential(credential).then((value) {
      finishLoginHospital(context);
    });
  } on Exception catch (e) {
    showSnackBar(context: context, content: e.toString());
  }
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
