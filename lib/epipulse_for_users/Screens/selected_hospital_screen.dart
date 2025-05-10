import 'package:epipulse/call/screens/incoming_call_screen.dart';
import 'package:flutter/material.dart';
import 'package:epipulse/epipulse_for_hospital/repositories/auth_repository.dart';
import 'package:epipulse/epipulse_for_users/Screens/ambulance_tracking.dart';
import 'package:epipulse/utils/colors.dart';
import 'package:epipulse/utils/custom_button.dart';
import 'package:epipulse/ambulance/ambulance_repository.dart';
import 'package:epipulse/models/hospital_model.dart';
import 'package:epipulse/utils/shortcuts.dart';
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
                if (medicalDetailsUid == 'UserNotFound') {
                  if (context.mounted) {
                    showSnackBar(context: context, content: 'UserNotFound');
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
    final hasPhone = widget.hospital.phoneNumber != null && widget.hospital.phoneNumber!.trim().isNotEmpty;
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
            Text(
              widget.hospital.name,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
            ),
            const SizedBox(height: 10),
            Text(
              widget.hospital.address ?? 'Address not available',
              style: const TextStyle(fontSize: 16, color: Colors.black54),
            ),
            const SizedBox(height: 30),
            const Text(
              'Contact',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 10),
            hasPhone
                ? CustomButton(
                    text: 'Call ${widget.hospital.phoneNumber}',
                    onPressed: () async {
                      await dial();
                    },
                    width: size.width * 0.94,
                    color: appBarColor,
                  )
                : CustomButton(
                    text: 'Phone number not available',
                    onPressed: () {},
                    width: size.width * 0.94,
                    color: Colors.grey,
                  ),
            const SizedBox(height: 40),
            const Text(
              'VIDEO CALL',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            StreamBuilder(
              stream: checkVidCallStatus(
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
                      width: size.width * 0.94,
                      onPressed: () {
                        if (snapshot.data != 2) {
                          requestVidCall(
                              widget.hospitalUid, widget.currentPosition);
                        }
                      },
                      text: snapshot.data == 1
                          ? 'Request'
                          : snapshot.data == 2
                              ? 'Request Sent'
                              : snapshot.data == 3
                                  ? 'Accepted : Request Again'
                                  : 'Declined : Request Again',
                      color: snapshot.data == 1
                          ? Colors.blue
                          : snapshot.data == 2
                              ? Colors.yellow
                              : snapshot.data == 3
                                  ? Colors.green
                                  : Colors.red,
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 40),
            const Text(
              'AMBULANCE',
              style: TextStyle(
                fontSize: 25,
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
                      width: size.width * 0.6,
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
                      width: size.width * 0.3,
                      onPressed: () {
                        if (snapshot.data == 3) {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => AmbulanceTracking(
                                  hospital: widget.hospital)));
                        }
                      },
                      text: 'Track',
                      color: snapshot.data==3?   appBarColor:Colors.grey,
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 40),
            const Text(
              'MEDICAL DETAILS',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            CustomButton(
              text: 'Share My Medical Details',
              onPressed: () => setMedicalDetailsUid(
                  widget.hospitalUid, auth.currentUser!.uid),
                      width: size.width * 0.94,
              color: appBarColor,
            ),
            const SizedBox(height: 25),
            CustomButton(
              text: 'Share Others Medical Details',
              onPressed: () async {
                await othersMedicalDetails();
              },
                      width: size.width * 0.94,
              color: appBarColor,
            ),
          ],
        ),
      ),
      hospitalUid: widget.hospitalUid,
    );
  }
}
