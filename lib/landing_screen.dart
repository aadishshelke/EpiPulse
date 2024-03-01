import 'package:emedoc/emedoc_for_hospital/Screens/login_screen_hospital.dart';
import 'package:emedoc/emedoc_for_users/Screens/login_screen.dart';
import 'package:emedoc/utils/colors.dart';
import 'package:flutter/material.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Who Are You',
          style: TextStyle(color: textColor, fontWeight: FontWeight.w700),
        ),
        backgroundColor: appBarColor,
      ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: size.height * 0.1),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const LoginScreenUser()),
              );
            },
            child: const Text(
              'User',
              style: TextStyle(color: textColor, fontSize: 18),
            ), // Set the text color and font size here
          ),
          SizedBox(width: size.width * 0.1),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const LoginScreenHospital()),
              );
            },
            child: const Text(
              'Hospital',
              style: TextStyle(color: textColor, fontSize: 18),
            ), // Set the text color and font size here
          ),
        ],
      ),
    );
  }
}
