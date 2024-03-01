import 'package:emedoc/models/hospital_model.dart';
import 'package:emedoc/emedoc_for_hospital/Screens/hospital_main_screen.dart';
import 'package:emedoc/emedoc_for_hospital/repositories/auth_repository.dart';
import 'package:emedoc/emedoc_for_users/Screens/main_entry_screen.dart';
import 'package:emedoc/models/user_model.dart';
import 'package:emedoc/emedoc_for_users/repositories/auth_repository.dart';
import 'package:emedoc/landing_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  Userinfo? user = await getCurrentUserData();
  Hospitalinfo? hospital = await getCurrentHospitalData();
  runApp(
    MaterialApp(
      home: user != null
          ? UserMainScreen()
          : hospital != null
              ? HospitalMainScreen()
              : LandingScreen(),
    ),
  );
}
