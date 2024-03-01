import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emedoc/emedoc_for_users/repositories/map_repository.dart';
import 'package:emedoc/models/hospital_model.dart';
import 'package:emedoc/emedoc_for_users/Screens/selected_hospital_screen.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  Position? _currentPosition;
  // List<Hospitalinfo> hospitalsList = [];
  Set<Marker> hospitalMarkers = {};

  @override
  void initState() {
    super.initState();
    getCurrentLocation();
    fetchHospitals();
  }

  void getCurrentLocation() async {
    Position cP = await determinePosition();
    setState(() {
      _currentPosition = cP;
    });
    hospitalMarkers.add(
      Marker(
        markerId: const MarkerId('You are here'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        position: LatLng(
          double.parse(_currentPosition!.latitude.toString()),
          double.parse(_currentPosition!.longitude.toString()),
        ),
      ),
    );
  }

  Future<void> fetchHospitals() async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await firestore.collection('hospitals').get();
      setState(() {
        for (QueryDocumentSnapshot<Map<String, dynamic>> doc
            in querySnapshot.docs) {
          String hospitalUid = doc.id;
          Hospitalinfo hospital = Hospitalinfo.fromMap(doc.data());

          // hospitalsList.add(hospital);

          hospitalMarkers.add(
            Marker(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SelectedHospitalScreen(
                    hospital: hospital,
                    hospitalUid: hospitalUid,
                    currentPosition: _currentPosition!,
                  ),
                ),
              ),
              markerId: MarkerId(hospital.name),
              icon: BitmapDescriptor.defaultMarker,
              position: LatLng(
                double.parse(hospital.latitude),
                double.parse(hospital.longtitude),
              ),
            ),
          );
        }
      });

      print('Hospitals fetched successfully:');
    } catch (e) {
      print('Error fetching hospitals: $e');
      // Handle the error as needed
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_currentPosition == null) {
      return const Scaffold(
        body: Center(
          child: Text('Getting Current Location...'),
        ),
      );
    }
    return Scaffold(
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: _currentPosition == null
              ? const LatLng(18.52043901726647, 73.86080675566187)
              : LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
          zoom: 12,
        ),
        markers: hospitalMarkers,
      ),
    );
  }
}
