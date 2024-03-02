import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emedoc/utils/shortcuts.dart';

import 'package:emedoc/emedoc_for_users/Screens/login_screen.dart';
import 'package:emedoc/emedoc_for_users/Screens/main_entry_screen.dart';
import 'package:emedoc/emedoc_for_users/Screens/otp_screen.dart';
import 'package:emedoc/emedoc_for_users/Screens/user_info_screen.dart';
import 'package:emedoc/models/user_model.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

final FirebaseAuth auth = FirebaseAuth.instance;
String verificationid = '';
Userinfo? currentUser;

void sendPhoneNumber(String phonenumber, BuildContext context) async {
  
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
          context, MaterialPageRoute(builder: (context) => OTPScreen()));

      // Sign the user in (or link) with the credential
    },
    codeAutoRetrievalTimeout: (String verificationId) {
      // Auto-resolution timed out...
    },
  );
}

void verifyOTP(String userOTP, BuildContext context) async {
  try {
    // Create a PhoneAuthCredential with the code
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationid, smsCode: userOTP);

    // Sign the user in (or link) with the credential
    await auth.signInWithCredential(credential).then((value) {
      finishLogin(context);
    });
  } on Exception catch (e) {
    showSnackBar(context: context, content: e.toString());
  }
}

Future<Userinfo?> getCurrentUserData() async {
  var userData = await FirebaseFirestore.instance
      .collection('users')
      .doc(auth.currentUser?.uid)
      .get();
  if (userData.data() != null) {
    currentUser = Userinfo.fromMap(userData.data()!);
  }
  return currentUser;
}

void finishLogin(BuildContext context) async {
  print('hi');
  var userData = await FirebaseFirestore.instance
      .collection('users')
      .doc(auth.currentUser?.uid)
      .get();
  if (userData.data() != null) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => UserMainScreen()));
  } else {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => UserInfoScreen()));
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
  Navigator.pushAndRemoveUntil(context,
      MaterialPageRoute(builder: (context) => LoginScreenUser()), (route) => false);
}
