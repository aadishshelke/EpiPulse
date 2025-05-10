import 'dart:async';
import 'package:epipulse/epipulse_for_users/repositories/map_repository.dart';
import 'package:epipulse/models/hospital_model.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AmbulanceTracking extends StatefulWidget {
  const AmbulanceTracking({
    super.key,
    required this.hospital,
  });
  final Hospitalinfo hospital;

  @override
  State<AmbulanceTracking> createState() => _AmbulanceTrackingState();
}

class _AmbulanceTrackingState extends State<AmbulanceTracking> {
  final Completer<GoogleMapController> _mapController =
      Completer<GoogleMapController>();

  static const LatLng _pGooglePlex = LatLng(37.4223, -122.0848);
  static const LatLng _pApplePark = LatLng(37.3346, -122.0090);

  @override
  void initState() {
    super.initState();
    getCurrentLocation();
  }

  Position? _currentPosition;
  LatLng? _currentP;
  void getCurrentLocation() async {
    Position cP = await determinePosition();
    setState(() {
      _currentPosition = cP;
      _currentP = LatLng(cP.latitude, cP.longitude);
    });
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
        onMapCreated: ((GoogleMapController controller) =>
            _mapController.complete(controller)),
        initialCameraPosition: const CameraPosition(
          target: _pGooglePlex,
          zoom: 13,
        ),
        markers: {
          Marker(
            markerId: const MarkerId("_currentLocation"),
            icon: BitmapDescriptor.defaultMarker,
            position: _currentP!,
          ),
          const Marker(
            markerId: MarkerId("_ambulanceLocation"),
            icon: BitmapDescriptor.defaultMarker,
            position: _pApplePark,
          ),
          const Marker(
            markerId: MarkerId("_destionationLocation"),
            icon: BitmapDescriptor.defaultMarker,
            position: _pGooglePlex,
          )
        },
      ),
    );
  }
}
