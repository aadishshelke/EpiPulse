import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emedoc/emedoc_for_hospital/Widget/get_userdata.dart';
import 'package:emedoc/models/emergency_model.dart';
import 'package:emedoc/emedoc_for_users/repositories/auth_repository.dart';
import 'package:geolocator/geolocator.dart';

Future<void> setEmergency(String hospitalUid, Position currrentLocation) async {
  double latitude = currrentLocation.latitude;
  double longitude = currrentLocation.longitude;

  DocumentSnapshot emeSnapshot = await FirebaseFirestore.instance
      .collection('emergency')
      .doc(hospitalUid)
      .collection('users')
      .doc(auth.currentUser!.uid)
      .get();

  if (!emeSnapshot.exists) {
    EmergencyModel eme = EmergencyModel(
      patientUid: auth.currentUser!.uid,
      patientName: currentUser!.firstName,
      hospitalUid: hospitalUid,
      ambulanceStatus: 1,
      latitude: latitude.toString(),
      longtitude: longitude.toString(),
      vidCallStatus: 1,
      callId: 'NotYetProvided',
      medicalDetailsUid: 'NotYetProvided',
    );

    try {
      await FirebaseFirestore.instance
          .collection('emergency')
          .doc(hospitalUid)
          .collection('users')
          .doc(auth.currentUser!.uid)
          .set(eme.toMap());
    } on Exception catch (e) {
      print('Error setting initial emergency: $e');
    }
  } else {
    print('Emergency data already exists.');
  }
}

Future<void> requestAmbulance(
    String hospitalUid, Position currrentLocation) async {
  await setEmergency(hospitalUid, currrentLocation);
  try {
    await FirebaseFirestore.instance
        .collection('emergency')
        .doc(hospitalUid)
        .collection('users')
        .doc(auth.currentUser!.uid)
        .update({'ambulanceStatus': 1});

    updateAmbulanceStatus(hospitalUid, auth.currentUser!.uid, 2);
  } catch (e) {
    print('Error requesting ambulance: $e');
  }
}

Future<void> requestVidCall(
    String hospitalUid, Position currrentLocation) async {
  await setEmergency(hospitalUid, currrentLocation);
  try {
    await FirebaseFirestore.instance
        .collection('emergency')
        .doc(hospitalUid)
        .collection('users')
        .doc(auth.currentUser!.uid)
        .update({'vidCallStatus': 1});

    updateVidCallStatus(hospitalUid, auth.currentUser!.uid, 2);
  } catch (e) {
    print('Error requesting Video Call: $e');
  }
}

Stream<int> checkAmbulanceStatus(String hospitalUid, String userUid) {
  return firestore
      .collection('emergency')
      .doc(hospitalUid)
      .collection('users')
      .doc(userUid)
      .snapshots()
      .map((event) {
    if (event.exists) {
      return event.data()!['ambulanceStatus'] ?? 1;
    } else {
      return 1;
    }
  });
}

Stream<int> checkVidCallStatus(String hospitalUid, String userUid) {
  return firestore
      .collection('emergency')
      .doc(hospitalUid)
      .collection('users')
      .doc(userUid)
      .snapshots()
      .map((event) {
    if (event.exists) {
      return event.data()!['vidCallStatus'] ?? 1;
    } else {
      return 1;
    }
  });
}

void updateAmbulanceStatus(
    String hospitalUid, String patientUid, int value) async {
  await FirebaseFirestore.instance
      .collection('emergency')
      .doc(hospitalUid)
      .collection('users')
      .doc(patientUid)
      .update({'ambulanceStatus': value});
}

void updateVidCallStatus(
    String hospitalUid, String patientUid, int value) async {
  await FirebaseFirestore.instance
      .collection('emergency')
      .doc(hospitalUid)
      .collection('users')
      .doc(patientUid)
      .update({'vidCallStatus': value});
}

Future<void> setMedicalDetailsUid(String hospitalUid, String uid) async {
  try {
    await FirebaseFirestore.instance
        .collection('emergency')
        .doc(hospitalUid)
        .collection('users')
        .doc(auth.currentUser!.uid)
        .update({'medicalDetailsUid': uid});
  } catch (e) {
    print('Error setting Medical Details Uid: $e');
  }
}

Future<String> getMedicalDetailsUidwithPhoneNumber(String number) async {
  QuerySnapshot querySnapshot =
      await FirebaseFirestore.instance.collection('users').get();

  for (var doc in querySnapshot.docs) {
    if (doc['phoneNumber'] == number) {
      return doc.id;
    }
  }
  return 'UserNotFound';
}

Future<String> checkMedicalDetailsUid(String hospitalUid, String userUid) async {
  var snapshot = await FirebaseFirestore.instance
      .collection('emergency')
      .doc(hospitalUid)
      .collection('users')
      .doc(userUid)
      .get();

  if (snapshot.exists) {
    return snapshot.data()?['detailsUid'] ?? 'NotYetProvided';
  }
  return 'NotYetProvided';
}
