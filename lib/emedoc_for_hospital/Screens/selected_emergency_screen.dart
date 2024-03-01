import 'package:emedoc/ambulance/ambulance_repository.dart';
import 'package:emedoc/emedoc_for_hospital/Screens/get_user_details.dart';
import 'package:emedoc/emedoc_for_hospital/Widget/get_userdata.dart';
import 'package:emedoc/models/emergency_model.dart';
import 'package:emedoc/models/user_model.dart';
import 'package:emedoc/utils/colors.dart';
import 'package:emedoc/utils/custom_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

FirebaseAuth auth = FirebaseAuth.instance;

class Selectedemergency extends StatefulWidget {
  final EmergencyModel emergency;
  const Selectedemergency({super.key, required this.emergency});

  @override
  State<Selectedemergency> createState() => _SelectedemergencyState();
}

class _SelectedemergencyState extends State<Selectedemergency> {
  Userinfo? patient;
  Userinfo? medicalDetailsUser;

  @override
  void initState() {
    super.initState();
    getUser();
    getMedicalDetailsUser();
  }

  void getUser() async {
    Userinfo? temp = await getCurrentUserData(widget.emergency.patientUid);
    setState(() {
      patient = temp;
    });
  }

  void getMedicalDetailsUser() async {
    String tempuid = await checkMedicalDetailsUid(
        auth.currentUser!.uid, widget.emergency.patientUid);
    medicalDetailsUser = await getCurrentUserData(tempuid);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    if (patient == null) {
      return const Scaffold(
        body: Center(
          child: Text('Getting User Details...'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          patient!.firstName,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
        ),
        backgroundColor: appBarColor,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.all(8.0),
              height: size.height * 0.2,
              child: StreamBuilder(
                stream: checkAmbulanceStatus(
                    widget.emergency.hospitalUid, widget.emergency.patientUid),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }
                  return Column(
                    children: [
                      const SizedBox(height: 15),
                      snapshot.data == 1
                          ? const Text(
                              'Ambulance not yet called',
                              style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15),
                            )
                          : snapshot.data == 2
                              ? Text(
                                  'Ambulance requested by user',
                                  style: TextStyle(
                                      color: Colors.yellow[700],
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
                                )
                              : snapshot.data == 3
                                  ? const Text(
                                      'Ambulance request accepted',
                                      style: TextStyle(
                                          color: Colors.green,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15),
                                    )
                                  : const Text(
                                      'Ambulance request declined',
                                      style: TextStyle(
                                          color: Colors.red,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15),
                                    ),
                      const SizedBox(height: 7),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          CustomButton(
                            onPressed: () {
                              updateAmbulanceStatus(
                                  widget.emergency.hospitalUid,
                                  widget.emergency.patientUid,
                                  3);
                            },
                            text: 'Accept',
                            color: Colors.green,
                            width: size.width * 0.4,
                          ),
                          CustomButton(
                            onPressed: () {
                              updateAmbulanceStatus(
                                  widget.emergency.hospitalUid,
                                  widget.emergency.patientUid,
                                  4);
                            },
                            text: 'Decline',
                            width: size.width * 0.4,
                            color: Colors.red,
                          )
                        ],
                      )
                      //userdetails
                    ],
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CustomButton(
                  text: 'Open user details',
                  onPressed: () {
                    if (medicalDetailsUser != null) {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) =>
                              Userdetailscreen(user: medicalDetailsUser!),
                        ),
                      );
                    }
                  },
                  width: size.width * 0.7,
                  color: appBarColor,
                ),
                IconButton(
                  onPressed: getMedicalDetailsUser,
                  icon: const Icon(Icons.refresh_outlined),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
