import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emedoc/call/screens/call_screen.dart';
import 'package:emedoc/utils/shortcuts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

final FirebaseFirestore firestore = FirebaseFirestore.instance;
final FirebaseAuth auth = FirebaseAuth.instance;

Stream<DocumentSnapshot> callStream(String hospitalUid) {
  String patientUid = auth.currentUser!.uid;
  return firestore
      .collection('emergency')
      .doc(hospitalUid)
      .collection('users')
      .doc(patientUid)
      .snapshots();
}

void makeCall({
  required BuildContext context,
  required String patientUid,
  required String hospitalUid,
}) async {
  String callId = const Uuid().v1();
  try {
    await firestore
        .collection('emergency')
        .doc(hospitalUid)
        .collection('users')
        .doc(patientUid)
        .update({'callId': callId});

    if (!context.mounted) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CallScreen(
          channelId: callId,
          hospitalUid: hospitalUid,
          patientUid: patientUid,
        ),
      ),
    );
  } catch (e) {
    showSnackBar(context: context, content: e.toString());
  }
}

void endCall({
  required BuildContext context,
  required String patientUid,
  required String hospitalUid,
}) async {
  try {
    await firestore
        .collection('emergency')
        .doc(hospitalUid)
        .collection('users')
        .doc(patientUid)
        .update({'callId': ''});

    if (!context.mounted) return;

    Navigator.of(context).pop();
  } catch (e) {
    showSnackBar(context: context, content: e.toString());
  }
}
