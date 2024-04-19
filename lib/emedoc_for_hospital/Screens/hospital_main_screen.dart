import 'package:emedoc/emedoc_for_hospital/Screens/hospital_info_screen.dart';
import 'package:emedoc/emedoc_for_hospital/Screens/selected_emergency_screen.dart';
import 'package:emedoc/emedoc_for_hospital/Widget/get_userdata.dart';
import 'package:emedoc/emedoc_for_hospital/repositories/auth_repository.dart';
import 'package:emedoc/models/emergency_model.dart';
import 'package:emedoc/utils/colors.dart';
import 'package:flutter/material.dart';

class HospitalMainScreen extends StatefulWidget {
  const HospitalMainScreen({super.key});

  @override
  State<HospitalMainScreen> createState() => _HospitalMainScreenState();
}

class _HospitalMainScreenState extends State<HospitalMainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarColor,
        title: const Text(
          'Emergencies',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
        ),
        actions: [
          PopupMenuButton(
            icon: const Icon(
              Icons.more_vert,
              color: Color.fromARGB(255, 14, 13, 13),
            ),
            itemBuilder: (context) => [
              PopupMenuItem(
                  child: const Text(
                    'Log out',
                  ),
                  onTap: () => signOutHospital(context)),
              PopupMenuItem(
                child: const Text(
                  'Update Information',
                ),
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const HospitalInfoScreen())),
              )
            ],
          ),
        ],
      ),
      body: StreamBuilder<List<EmergencyModel>>(
        stream: getEmergencies(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(
                child: Text('Loading'),
              ),
            );
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Scaffold(
              body: Center(
                child: Text('No Emergencies Yet'),
              ),
            );
          }
          return SingleChildScrollView(
            child: ListView.builder(
              itemCount: snapshot.data!.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                var emergency = snapshot.data![index];

                return ListTile(
                  title: Text(
                    emergency.patientName,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 17),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            Selectedemergency(emergency: emergency),
                      ),
                    );
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}
