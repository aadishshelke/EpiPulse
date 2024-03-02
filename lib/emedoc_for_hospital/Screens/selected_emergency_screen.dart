import 'package:emedoc/ambulance/ambulance_repository.dart';
import 'package:emedoc/call/repository/call_repository.dart';
import 'package:emedoc/emedoc_for_hospital/Screens/get_user_details.dart';
import 'package:emedoc/emedoc_for_hospital/Widget/get_userdata.dart';
import 'package:emedoc/models/emergency_model.dart';
import 'package:emedoc/models/user_model.dart';
import 'package:emedoc/utils/colors.dart';
import 'package:emedoc/utils/custom_button.dart';
import 'package:emedoc/utils/shortcuts.dart';
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
      body: Column(
        children: [
          const SizedBox(height: 50),
          StreamBuilder(
            stream: checkVidCallStatus(
                widget.emergency.hospitalUid, widget.emergency.patientUid),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              }
              return Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: size.width * 0.45,
                        child: const Text(
                          '  VIDEO CAll',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      SizedBox(
                        width: size.width * 0.45,
                        child: snapshot.data == 1
                            ? const Text(
                                'Not Yet Requested',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20),
                              )
                            : snapshot.data == 2
                                ? Text(
                                    'Requested',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.yellow[700],
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                  )
                                : snapshot.data == 3
                                    ? const Text(
                                        'Completed',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Colors.green,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20),
                                      )
                                    : const Text(
                                        'Declined',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Colors.red,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20),
                                      ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 7),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      CustomButton(
                        onPressed: () {
                          if (snapshot.data == 2) {
                            makeCall(
                                context: context,
                                patientUid: widget.emergency.patientUid,
                                hospitalUid: widget.emergency.hospitalUid);
                            updateVidCallStatus(widget.emergency.hospitalUid,
                                widget.emergency.patientUid, 3);
                          }
                        },
                        text: 'Accept',
                        color: snapshot.data == 2 ? Colors.green : Colors.grey,
                        width: size.width * 0.6,
                      ),
                      CustomButton(
                        onPressed: () {
                          if (snapshot.data == 2) {
                            updateVidCallStatus(widget.emergency.hospitalUid,
                                widget.emergency.patientUid, 4);
                          }
                        },
                        text: 'Decline',
                        width: size.width * 0.3,
                        color: snapshot.data == 2 ? Colors.red : Colors.grey,
                      )
                    ],
                  )
                  //userdetails
                ],
              );
            },
          ),
          const SizedBox(height: 50),
          StreamBuilder(
            stream: checkAmbulanceStatus(
                widget.emergency.hospitalUid, widget.emergency.patientUid),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              }
              return Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: size.width * 0.45,
                        child: const Text(
                          '  AMBULANCE',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      SizedBox(
                        width: size.width * 0.45,
                        child: snapshot.data == 1
                            ? const Text(
                                'Not Yet Requested',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20),
                              )
                            : snapshot.data == 2
                                ? Text(
                                    'Requested',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.yellow[700],
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                  )
                                : snapshot.data == 3
                                    ? const Text(
                                        'Accepted',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Colors.green,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20),
                                      )
                                    : const Text(
                                        'Declined',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Colors.red,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20),
                                      ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 7),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      CustomButton(
                        onPressed: () {
                          if (snapshot.data != 1) {
                            updateAmbulanceStatus(widget.emergency.hospitalUid,
                                widget.emergency.patientUid, 3);
                          }
                        },
                        text: 'Accept',
                        color: snapshot.data == 1 ? Colors.grey : Colors.green,
                        width: size.width * 0.6,
                      ),
                      CustomButton(
                        onPressed: () {
                          if (snapshot.data != 1) {
                            updateAmbulanceStatus(widget.emergency.hospitalUid,
                                widget.emergency.patientUid, 4);
                          }
                        },
                        text: 'Decline',
                        width: size.width * 0.3,
                        color: snapshot.data == 1 ? Colors.grey : Colors.red,
                      )
                    ],
                  )
                  //userdetails
                ],
              );
            },
          ),
          const SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: size.width * 0.6,
                child: const Text(
                  'MEDICAL DETAILS',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              SizedBox(width: size.width * 0.3),
            ],
          ),
          const SizedBox(height: 10),
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
                  } else {
                    showSnackBar(
                        context: context,
                        content: 'User Details Not Yet Provided');
                  }
                },
                width: size.width * 0.78,
                color: appBarColor,
              ),
              IconButton(
                onPressed: getMedicalDetailsUser,
                icon: const Icon(Icons.refresh_outlined),
              ),
            ],
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
