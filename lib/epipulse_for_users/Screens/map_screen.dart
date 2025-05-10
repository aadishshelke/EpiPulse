import 'dart:async';
import 'dart:math';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:epipulse/epipulse_for_users/repositories/map_repository.dart';
import 'package:epipulse/models/hospital_model.dart';
import 'package:epipulse/epipulse_for_users/Screens/selected_hospital_screen.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:epipulse/epipulse_for_users/Screens/simple_hospital_details_screen.dart';

const String googlePlacesApiKey = 'AIzaSyAK2TdmqoR_3lxP_KE3jHlLR5S03pTuwS8'; // <-- Replace with your key

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  Position? _currentPosition;
  LatLng? _selectedPosition;
  Set<Marker> hospitalMarkers = {};
  List<Map<String, dynamic>> placesHospitals = [];

  @override
  void initState() {
    super.initState();
    getCurrentLocation();
  }

  void getCurrentLocation() async {
    try {
      Position cP = await determinePosition();
      setState(() {
        _currentPosition = cP;
        _selectedPosition = LatLng(cP.latitude, cP.longitude);
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error getting location: ${e.toString()}'),
            duration: const Duration(seconds: 5),
          ),
        );
      }
    }
  }

  Future<void> fetchNearbyHospitals(LatLng location) async {
    final url =
        'https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=${location.latitude},${location.longitude}&radius=10000&type=hospital&key=$googlePlacesApiKey';
    final response = await http.get(Uri.parse(url));
    print('Google Places API response: ' + response.body); // Debug print
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List results = data['results'];
      setState(() {
        placesHospitals = results.map<Map<String, dynamic>>((place) => place as Map<String, dynamic>).toList();
        hospitalMarkers = results.map<Marker>((place) {
          final lat = place['geometry']['location']['lat'];
          final lng = place['geometry']['location']['lng'];
          return Marker(
            markerId: MarkerId(place['place_id']),
            position: LatLng(lat, lng),
            infoWindow: InfoWindow(title: place['name']),
          );
        }).toSet();
      });
    } else {
      setState(() {
        placesHospitals = [];
        hospitalMarkers = {};
      });
    }
  }

  double calculateDistance(LatLng start, LatLng end) {
    const double earthRadius = 6371000; // meters
    final dLat = (end.latitude - start.latitude) * pi / 180.0;
    final dLng = (end.longitude - start.longitude) * pi / 180.0;
    final a = sin(dLat / 2) * sin(dLat / 2) +
        cos(start.latitude * pi / 180.0) *
            cos(end.latitude * pi / 180.0) *
            sin(dLng / 2) * sin(dLng / 2);
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return earthRadius * c;
  }

  void showHospitalSelectionSheet(BuildContext context) async {
    await fetchNearbyHospitals(_selectedPosition!);
    if (placesHospitals.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No hospitals found nearby!')),
      );
      return;
    }
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Nearest hospitals to you',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.builder(
                itemCount: placesHospitals.length,
                itemBuilder: (context, index) {
                  final hospital = placesHospitals[index];
                  final name = hospital['name'] ?? 'Unknown';
                  final address = hospital['vicinity'] ?? '';
                  final lat = hospital['geometry']['location']['lat'];
                  final lng = hospital['geometry']['location']['lng'];
                  final distance = calculateDistance(
                    _selectedPosition!,
                    LatLng(lat, lng),
                  );
                  final distanceStr = distance < 1000
                      ? '${distance.toStringAsFixed(0)} m'
                      : '${(distance / 1000).toStringAsFixed(2)} km';
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    child: Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        title: Text(
                          name,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              address,
                              style: const TextStyle(fontSize: 13, color: Colors.black54),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Distance: $distanceStr',
                              style: const TextStyle(fontSize: 12, color: Colors.blueGrey),
                            ),
                          ],
                        ),
                        onTap: () {
                          Navigator.pop(context); // Close the sheet
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SimpleHospitalDetailsScreen(
                                name: name,
                                address: address,
                                latitude: lat,
                                longitude: lng,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_currentPosition == null || _selectedPosition == null) {
      return const Scaffold(
        body: Center(
          child: Text('Getting Current Location...'),
        ),
      );
    }
    Set<Marker> allMarkers = Set.from(hospitalMarkers);
    // Add the user-selected marker
    allMarkers.add(
      Marker(
        markerId: const MarkerId('You are here'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        position: _selectedPosition!,
        draggable: true,
        onDragEnd: (newPosition) {
          setState(() {
            _selectedPosition = newPosition;
          });
        },
      ),
    );
    return Scaffold(
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: _selectedPosition!,
          zoom: 12,
        ),
        markers: allMarkers,
        onTap: (LatLng tappedPoint) {
          setState(() {
            _selectedPosition = tappedPoint;
          });
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showHospitalSelectionSheet(context);
        },
        label: const Text('Confirm Location'),
        icon: const Icon(Icons.check),
      ),
    );
  }
}
