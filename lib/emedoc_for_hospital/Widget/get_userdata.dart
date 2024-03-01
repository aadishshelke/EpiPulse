import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emedoc/emedoc_for_hospital/repositories/auth_repository.dart';
import 'package:emedoc/models/emergency_model.dart';
import 'package:emedoc/models/user_model.dart';

FirebaseFirestore firestore = FirebaseFirestore.instance;

Future<Userinfo?> getCurrentUserData(String uid) async {
  Userinfo? currentUser;
  var userData =
      await FirebaseFirestore.instance.collection('users').doc(uid).get();
  if (userData.data() != null) {
    currentUser = Userinfo.fromMap(userData.data()!);
  }
  return currentUser;
}

Stream<List<EmergencyModel>> getEmergencies() async* {
  var snapshot = await firestore
      .collection('emergency')
      .doc(auth.currentUser!.uid)
      .collection('users')
      .get();

  List<EmergencyModel> emergencyCalls = [];
  for (var doc in snapshot.docs) {
    // String uid = doc.id;
    EmergencyModel? emergency = EmergencyModel.fromMap(doc.data());
    emergencyCalls.add(emergency);
  }

  yield emergencyCalls;
}
