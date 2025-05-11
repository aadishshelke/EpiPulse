import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:epipulse/video_call_screen.dart';

class SimpleHospitalDetailsScreen extends StatelessWidget {
  final String name;
  final String address;
  final double latitude;
  final double longitude;
  final String? phoneNumber;

  const SimpleHospitalDetailsScreen({
    Key? key,
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
    this.phoneNumber,
  }) : super(key: key);

  static const Color mainColor = Color.fromRGBO(204, 227, 222, 1);

  @override
  Widget build(BuildContext context) {
    final String displayPhone = (phoneNumber != null && phoneNumber!.trim().isNotEmpty)
        ? phoneNumber!
        : '7058882713';
    return Scaffold(
      backgroundColor: mainColor,
      appBar: AppBar(
        backgroundColor: mainColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
        title: Text(
          name,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 25, color: Colors.black87),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                color: Colors.white,
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.location_on, color: Colors.teal, size: 20),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(address, style: const TextStyle(fontSize: 15, color: Colors.black54)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: SizedBox(
                  height: 180,
                  child: GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: LatLng(latitude, longitude),
                      zoom: 15,
                    ),
                    markers: {
                      Marker(
                        markerId: const MarkerId('hospital'),
                        position: LatLng(latitude, longitude),
                      ),
                    },
                    zoomControlsEnabled: false,
                    myLocationButtonEnabled: false,
                    liteModeEnabled: true,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              _buildActionButton(
                context,
                icon: Icons.local_hospital,
                label: 'Request Ambulance',
                color: Colors.redAccent,
                onPressed: () {
                  _showDetailsDialog(
                    context,
                    'Request Ambulance',
                    'Send Request',
                    'Request for ambulance sent.',
                  );
                },
              ),
              const SizedBox(height: 14),
              _buildActionButton(
                context,
                icon: Icons.calendar_today,
                label: 'Book an Appointment',
                color: Colors.blueAccent,
                onPressed: () {
                  _showDetailsDialog(
                    context,
                    'Book an Appointment',
                    'Book',
                    'Your appointment will be scheduled shortly.',
                  );
                },
              ),
              const SizedBox(height: 14),
              _buildActionButton(
                context,
                icon: Icons.phone,
                label: 'Call Hospital',
                color: Colors.teal,
                onPressed: () async {
                  final call = 'tel:$displayPhone';
                  if (await canLaunchUrl(Uri.parse(call))) {
                    await launchUrl(Uri.parse(call));
                  }
                },
              ),
              const SizedBox(height: 14),
              _buildActionButton(
                context,
                icon: Icons.video_call,
                label: 'Request Video Call',
                color: Colors.deepPurpleAccent,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => VideoCallScreen(channel: 'test_channel'),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton(BuildContext context, {required IconData icon, required String label, required Color color, required VoidCallback? onPressed}) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton.icon(
        icon: Icon(icon, size: 22),
        label: Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: onPressed != null ? 2 : 0,
        ),
        onPressed: onPressed,
      ),
    );
  }

  void _showDetailsDialog(BuildContext context, String title, String confirmText, String snackBarText) {
    final TextEditingController detailsController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: TextField(
            controller: detailsController,
            maxLines: 3,
            decoration: const InputDecoration(
              hintText: 'Describe symptoms, emergency, or reason...'
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(snackBarText)),
                );
                // Here you can add logic to send detailsController.text to backend
              },
              child: Text(confirmText),
            ),
          ],
        );
      },
    );
  }
} 