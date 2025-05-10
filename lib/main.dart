import 'package:epipulse/models/hospital_model.dart';
import 'package:epipulse/epipulse_for_hospital/Screens/hospital_main_screen.dart';
import 'package:epipulse/epipulse_for_hospital/repositories/auth_repository.dart';
import 'package:epipulse/epipulse_for_users/Screens/main_entry_screen.dart';
import 'package:epipulse/models/user_model.dart';
import 'package:epipulse/epipulse_for_users/repositories/auth_repository.dart';
import 'package:epipulse/landing_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print('Firebase initialized successfully');
  } catch (e) {
    print('Error initializing Firebase: $e');
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<Map<String, dynamic>> _initializeApp() async {
    try {
      Userinfo? user = await getCurrentUserData();
      Hospitalinfo? hospital = await getCurrentHospitalData();
      return {'user': user, 'hospital': hospital};
    } catch (e) {
      print('Error in _initializeApp: $e');
      return {'user': null, 'hospital': null};
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FutureBuilder<Map<String, dynamic>>(
        future: _initializeApp(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          } else if (snapshot.hasError) {
            return Scaffold(
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Error: ${snapshot.error}'),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        // Retry initialization
                        (context as Element).markNeedsBuild();
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          } else {
            final user = snapshot.data?['user'] as Userinfo?;
            final hospital = snapshot.data?['hospital'] as Hospitalinfo?;
            if (user != null) {
              return const UserMainScreen();
            } else if (hospital != null) {
              return const HospitalMainScreen();
            } else {
              return const LandingScreen();
            }
          }
        },
      ),
    );
  }
}
