import 'package:flutter/material.dart';
import 'package:emedoc/emedoc_for_users/Screens/map_screen.dart';
import 'package:emedoc/emedoc_for_users/Screens/user_info_screen.dart';
import 'package:emedoc/utils/colors.dart';
import 'package:emedoc/emedoc_for_users/repositories/auth_repository.dart';

class UserMainScreen extends StatefulWidget {
  const UserMainScreen({Key? key}) : super(key: key);

  @override
  State<UserMainScreen> createState() => _UserMainScreenState();
}

class _UserMainScreenState extends State<UserMainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarColor,
        title: const Text(
          'Welcome User',
         style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25),
        ),
        actions: [
          PopupMenuButton(
            icon: const Icon(
              Icons.more_vert,
              color: Color.fromARGB(255, 14, 13, 13),
            ),
            itemBuilder: (context) => [
              PopupMenuItem(
                child: const Text('Log out'),
                onTap: () => signOut(context),
              ),
              PopupMenuItem(
                child: const Text('Update Information'),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const UserInfoScreen()),
                ),
              )
            ],
          ),
        ],
      ),
      body: Center(
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MapPage()),
              );
              print('Emergency button pressed!');
            },
            borderRadius: BorderRadius.circular(150.0),
            child: Container(
              width: 200.0,
              height: 200.0,
              decoration: BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 10.0,
                    spreadRadius: 2.0,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Center(
                child: Text(
                  'Emergency',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
