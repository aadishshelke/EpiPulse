import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class EmergencyServicesScreen extends StatefulWidget {
  const EmergencyServicesScreen({Key? key}) : super(key: key);

  @override
  State<EmergencyServicesScreen> createState() => _EmergencyServicesScreenState();
}

class _EmergencyServicesScreenState extends State<EmergencyServicesScreen> {
  // Mock current location (latitude, longitude)
  LatLng currentLocation = const LatLng(19.0760, 72.8777); // Mumbai

  // Mock hospital data
  final List<Map<String, dynamic>> hospitals = [
    {
      'name': 'City General Hospital',
      'type': 'General',
      'latLng': LatLng(19.0800, 72.8800),
      'distance': '1.2 km',
    },
    {
      'name': 'Govt. Health Center',
      'type': 'Government',
      'latLng': LatLng(19.0700, 72.8700),
      'distance': '2.1 km',
    },
    {
      'name': 'Private Clinic',
      'type': 'Private',
      'latLng': LatLng(19.0780, 72.8850),
      'distance': '0.9 km',
    },
  ];

  GoogleMapController? _mapController;

  void _requestHelp() {
    // TODO: Send SOS to backend
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Help request sent with your location.')),
    );
  }

  void _callAmbulance() async {
    const ambulanceNumber = 'tel:108';
    if (await canLaunchUrl(Uri.parse(ambulanceNumber))) {
      await launchUrl(Uri.parse(ambulanceNumber));
    }
  }

  void _openInGoogleMaps(LatLng latLng) async {
    final url = 'https://www.google.com/maps/search/?api=1&query=${latLng.latitude},${latLng.longitude}';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Emergency Services'),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(32),
          child: Padding(
            padding: EdgeInsets.only(bottom: 8.0),
            child: Text(
              'Nearby Help & SOS',
              style: TextStyle(color: Colors.white70, fontSize: 15),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          // Map View
          SizedBox(
            height: 220,
            width: double.infinity,
            child: Stack(
              children: [
                GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: currentLocation,
                    zoom: 14,
                  ),
                  markers: {
                    Marker(
                      markerId: const MarkerId('current'),
                      position: currentLocation,
                      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
                      infoWindow: const InfoWindow(title: 'You are here'),
                    ),
                    ...hospitals.map((h) => Marker(
                          markerId: MarkerId(h['name']),
                          position: h['latLng'],
                          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
                          infoWindow: InfoWindow(title: h['name']),
                        )),
                  },
                  onMapCreated: (controller) => _mapController = controller,
                  myLocationEnabled: true,
                  myLocationButtonEnabled: true,
                  zoomControlsEnabled: false,
                ),
                Positioned(
                  right: 16,
                  top: 16,
                  child: FloatingActionButton.small(
                    heroTag: 'open_gmaps',
                    backgroundColor: Colors.white,
                    onPressed: () => _openInGoogleMaps(currentLocation),
                    child: const Icon(Icons.navigation, color: Colors.blue),
                  ),
                ),
              ],
            ),
          ),
          // Quick Access Buttons
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.sos, color: Colors.white),
                    label: const Text('Request Help'),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    onPressed: _requestHelp,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.local_hospital, color: Colors.white),
                    label: const Text('Call Ambulance'),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                    onPressed: _callAmbulance,
                  ),
                ),
              ],
            ),
          ),
          // Hospitals List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: hospitals.length,
              itemBuilder: (context, i) {
                final h = hospitals[i];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  child: ListTile(
                    leading: const Icon(Icons.local_hospital, color: Colors.red),
                    title: Text(h['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('${h['type']} • ${h['distance']}'),
                    trailing: ElevatedButton(
                      onPressed: () => _openInGoogleMaps(h['latLng']),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.green, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                      child: const Text('Get Directions'),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      // Floating alert for critical symptoms (optional, can be triggered by a flag)
      floatingActionButton: false // TODO: Show if user is critical
          ? FloatingActionButton.extended(
              onPressed: _callAmbulance,
              backgroundColor: Colors.red,
              icon: const Icon(Icons.warning),
              label: const Text('Your symptoms are serious. Call Ambulance?'),
            )
          : null,
    );
  }
} 