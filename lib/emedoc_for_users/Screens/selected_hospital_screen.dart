import 'package:emedoc/call/screens/incoming_call_screen.dart';
import 'package:flutter/material.dart';
import 'package:emedoc/emedoc_for_hospital/repositories/auth_repository.dart';
import 'package:emedoc/emedoc_for_users/Screens/ambulance_tracking.dart';
import 'package:emedoc/utils/colors.dart';
import 'package:emedoc/utils/custom_button.dart';
import 'package:emedoc/ambulance/ambulance_repository.dart';
import 'package:emedoc/models/hospital_model.dart';
import 'package:emedoc/utils/shortcuts.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';

class SelectedHospitalScreen extends StatefulWidget {
  const SelectedHospitalScreen({
    super.key,
    required this.hospital,
    required this.hospitalUid,
    required this.currentPosition,
  });

  final Hospitalinfo hospital;
  final String hospitalUid;
  final Position currentPosition;

  @override
  State<SelectedHospitalScreen> createState() => _SelectedHospitalScreenState();
}

class _SelectedHospitalScreenState extends State<SelectedHospitalScreen> {
  String medicalDetailsUid = '';

  Future<void> dial() async {
    final call = 'tel:${widget.hospital.phoneNumber}';
    if (await canLaunchUrl(Uri.parse(call))) {
      await launchUrl(Uri.parse(call));
    }
  }

  Future<void> othersMedicalDetails() async {
    TextEditingController textcontroller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Enter Phone Number'),
          content: TextField(
            controller: textcontroller,
            keyboardType: TextInputType.phone,
            decoration: const InputDecoration(
              hintText: 'Enter phone number',
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                medicalDetailsUid = await getMedicalDetailsUidwithPhoneNumber(
                    textcontroller.text);
                if (medicalDetailsUid == 'User not found') {
                  if (context.mounted) {
                    showSnackBar(context: context, content: 'User not found');
                  }
                } else {
                  setMedicalDetailsUid(widget.hospitalUid, medicalDetailsUid);
                }
              },
              child: const Text('Submit'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return IncomingCallScreen(
      widget: Scaffold(
        appBar: AppBar(
          backgroundColor: appBarColor,
          title: Text(
            widget.hospital.name,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 40),
            const Text(
              'DIRECT DIAL',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            CustomButton(
              text: 'Call ${widget.hospital.phoneNumber}',
              onPressed: () async {
                await dial();
              },
              width: size.width * 0.7,
              color: appBarColor,
            ),
            const SizedBox(height: 40),
            const Text(
              'VIDEO CONFERENCING',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            CustomButton(
              text: 'Request',
              onPressed: () {
                setState(() {
                  requestVidCall(widget.hospitalUid, widget.currentPosition);
                });
              },
              width: size.width * 0.7,
              color: Colors.blue, // Adjust button color
            ),
            const SizedBox(height: 40),
            const Text(
              'AMBULANCE',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            StreamBuilder(
              stream: checkAmbulanceStatus(
                  widget.hospitalUid, auth.currentUser!.uid),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: Text('Loading...'),
                  );
                }
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CustomButton(
                      width: size.width * 0.45,
                      onPressed: () {
                        if (snapshot.data == 1) {
                          requestAmbulance(
                              widget.hospitalUid, widget.currentPosition);
                        }
                      },
                      text: snapshot.data == 1
                          ? 'Request Ambulance'
                          : snapshot.data == 2
                              ? 'Request Sent'
                              : snapshot.data == 3
                                  ? 'Request Accepted'
                                  : 'Request Declined',
                      color: snapshot.data == 1
                          ? Colors.blue
                          : snapshot.data == 2
                              ? Colors.yellow
                              : snapshot.data == 3
                                  ? Colors.green
                                  : Colors.red,
                    ),
                    CustomButton(
                      width: size.width * 0.45,
                      onPressed: () {
                        if (snapshot.data == 3) {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => AmbulanceTracking(
                                  hospital: widget.hospital)));
                        }
                      },
                      text: 'Track',
                      color: appBarColor,
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 40),
            const Text(
              'SHARE DETAILS',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            CustomButton(
              text: 'Share My Medical Details',
              onPressed: () => setMedicalDetailsUid(
                  widget.hospitalUid, auth.currentUser!.uid),
              width: size.width * 0.7,
              color: appBarColor,
            ),
            const SizedBox(height: 25),
            CustomButton(
              text: 'Share Others Medical Details',
              onPressed: () async {
                await othersMedicalDetails();
              },
              width: size.width * 0.7,
              color: appBarColor,
            ),
          ],
        ),
      ),
      hospitalUid: widget.hospitalUid,
    );
  }
}
