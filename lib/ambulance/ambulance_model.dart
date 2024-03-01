import 'package:emedoc/models/hospital_model.dart';
import 'package:emedoc/models/user_model.dart';

class Ambulanceinfo {
  final Userinfo user;
  final Hospitalinfo hospital;

  Ambulanceinfo({
    required this.user,
    required this.hospital,
  });

  Map<String, dynamic> toMap() {
    return {
      'user': user.toMap(),
      'hospital': hospital.toMap(),
    };
  }

  factory Ambulanceinfo.fromMap(Map<String, dynamic> map) {
    return Ambulanceinfo(
      user: Userinfo.fromMap(map['user']),
      hospital: Hospitalinfo.fromMap(map['hospital']),
    );
  }
}
