class EmergencyModel {
  String patientUid;
  String patientName;
  String hospitalUid;

  int ambulanceStatus;
  String latitude;
  String longtitude;

  int vidCallStatus;
  String callId;

  String medicalDetailsUid;

  EmergencyModel({
    required this.patientUid,
    required this.patientName,
    required this.hospitalUid,

    required this.ambulanceStatus,
    required this.latitude,
    required this.longtitude,

    required this.vidCallStatus,
    required this.callId,

    required this.medicalDetailsUid,
  });

  Map<String, dynamic> toMap() {
    return {
      'patientUid': patientUid,
      'patientName': patientName,
      'hospitalUid': hospitalUid,

      'ambulanceStatus': ambulanceStatus,
      'latitude': latitude,
      'longtitude': longtitude,
      
      'vidCallStatus': vidCallStatus,
      'callId': callId,

      'medicalDetailsUid': medicalDetailsUid,
    };
  }

  factory EmergencyModel.fromMap(Map<String, dynamic> map) {
    return EmergencyModel(
      patientUid: map['patientUid'] ?? '',
      patientName: map['patientName'] ?? '',
      hospitalUid: map['hospitalUid'] ?? '',

      ambulanceStatus: map['ambulanceStatus'] ?? 1,
      latitude: map['latitude'] ?? '',
      longtitude: map['longtitude'] ?? '',

      vidCallStatus: map['vidCallStatus'] ?? 1,
      callId: map['callId'] ?? 'NotYetProvided',

      medicalDetailsUid: map['medicalDetailsUid'] ?? 'NotYetProvided',
    );
  }
}
