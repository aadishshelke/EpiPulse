
class Hospitalinfo {
  String name;
  String address;
  String phoneNumber;
  String latitude;
  String longtitude;

  Hospitalinfo({
    required this.name,
    required this.address,
    required this.phoneNumber,
    required this.latitude,
    required this.longtitude,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'address': address,
      'phoneNumber': phoneNumber,
      'latitude': latitude,
      'longtitude': longtitude,
    };
  }

 factory Hospitalinfo.fromMap(Map<String, dynamic> map) {
    return Hospitalinfo(
      name: map['name'] ?? '',
      address: map['address'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      latitude: map['latitude'] ?? '',
      longtitude: map['longtitude'] ?? '',
    );
  }
}
