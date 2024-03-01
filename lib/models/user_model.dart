class Userinfo {
  String firstName;
  String lasttName;
  String address;
  String phoneNumber;
  String bloodGroup;
  bool diabeties;
  String allergies;
  bool hypertension;
  bool asthama;
  String nameOfFamilyDoc;
  String numOfFamilyDoc;
  String specialInstructions;
  Userinfo({
    required this.firstName,
    required this.lasttName,
    required this.address,
    required this.phoneNumber,
    required this.bloodGroup,
    required this.diabeties,
    required this.allergies,
    required this.hypertension,
    required this.asthama,
    required this.nameOfFamilyDoc,
    required this.numOfFamilyDoc,
    required this.specialInstructions,
  });
  Map<String, dynamic> toMap() {
    return {
      'firstName': firstName,
      'lasttName': lasttName,
      'address': address,
      'phoneNumber': phoneNumber,
      'bloodGroup': bloodGroup,
      'diabeties': diabeties,
      'allergies': allergies,
      'hypertension': hypertension,
      'asthama': asthama,
      'nameOfFamilyDoc': nameOfFamilyDoc,
      'numOfFamilyDoc': numOfFamilyDoc,
      'specialInstructions': specialInstructions,
    };
  }

  factory Userinfo.fromMap(Map<String, dynamic> map) {
    return Userinfo(
      firstName: map['firstName'] ?? '',
      lasttName: map['lasttName'] ?? '',
      address: map['address'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      bloodGroup: map['bloodGroup'] ?? '',
      diabeties: map['diabeties'] ?? false,
      allergies: map['allergies'] ?? '',
      hypertension: map['hypertension'] ?? false,
      asthama: map['asthama'] ?? false,
      nameOfFamilyDoc: map['nameOfFamilyDoc'] ?? '',
      numOfFamilyDoc: map['numOfFamilyDoc'] ?? '',
      specialInstructions: map['specialInstructions'] ?? '',
    );
  }
}
