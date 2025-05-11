import 'package:flutter/material.dart';
import 'package:epipulse/epipulse_for_users/Screens/map_screen.dart';
import 'package:epipulse/epipulse_for_users/Screens/symptoms_questionnaire_screen.dart';
import 'package:epipulse/epipulse_for_users/Screens/water_quality_screen.dart';
import 'package:epipulse/epipulse_for_users/Screens/live_alerts_screen.dart';
import 'package:epipulse/epipulse_for_users/Screens/emergency_services_screen.dart';

class SymptomReportingScreen extends StatefulWidget {
  const SymptomReportingScreen({Key? key}) : super(key: key);

  @override
  _SymptomReportingScreenState createState() => _SymptomReportingScreenState();
}

class _SymptomReportingScreenState extends State<SymptomReportingScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
    
  @override
  void initState() {
    super.initState();
    _nameController.addListener(_onFormChanged);
    _ageController.addListener(_onFormChanged);
    _phoneController.addListener(_onFormChanged);
  }

  void _onFormChanged() {
    setState(() {});
  }

  @override
  void dispose() {
    _nameController.removeListener(_onFormChanged);
    _ageController.removeListener(_onFormChanged);
    _phoneController.removeListener(_onFormChanged);
    _nameController.dispose();
    _ageController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text('Symptom Reporting', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [Icon(Icons.help_outline, color: Colors.black)],
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Name Input
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.person_outline),
                  hintText: 'Enter your name',
                  filled: true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                ),
              ),
              const SizedBox(height: 12),
              // Age Input
              TextField(
                controller: _ageController,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.calendar_today_outlined),
                  hintText: 'Enter your age',
                  filled: true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),
              // Phone Input
              TextField(
                controller: _phoneController,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.phone_outlined),
                  hintText: 'Enter your phone number',
                  filled: true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                ),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16),
              // Location Row
              Row(
                children: const [
                  Icon(Icons.location_on_outlined, color: Colors.black54),
                  SizedBox(width: 6),
                  Text("Location detected automatically", style: TextStyle(color: Colors.black54)),
                ],
              ),
              const SizedBox(height: 16),
              // Action Buttons Row
              SizedBox(
                height: 44,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Report Symptoms (active, outlined)
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.only(right: 6),
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const SymptomsQuestionnaireScreen()),
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFF5B6DF6),
                            side: const BorderSide(color: Color(0xFF5B6DF6), width: 2),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            padding: EdgeInsets.zero,
                          ),
                          child: const Text('Report Symptoms', textAlign: TextAlign.center, style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ),
                    // Water Quality
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 3),
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const WaterQualityScreen()),
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.black87,
                            side: const BorderSide(color: Color(0xFF5B6DF6)),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            padding: EdgeInsets.zero,
                          ),
                          child: const Text('Water Quality', textAlign: TextAlign.center, style: TextStyle(fontSize: 13)),
                        ),
                      ),
                    ),
                    // Live Alerts
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 3),
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const LiveAlertsScreen()),
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.black87,
                            side: const BorderSide(color: Color(0xFF5B6DF6)),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            padding: EdgeInsets.zero,
                          ),
                          child: const Text('Live Alerts', textAlign: TextAlign.center, style: TextStyle(fontSize: 13)),
                        ),
                      ),
                    ),
                    // Emergency Services
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.only(left: 6),
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const MapPage()),
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.black87,
                            side: const BorderSide(color: Color(0xFF5B6DF6)),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            padding: EdgeInsets.zero,
                          ),
                          child: const Text('Emergency Services', textAlign: TextAlign.center, style: TextStyle(fontSize: 13)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // Recorded Input
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.mic_none, color: Colors.black54),
                  SizedBox(width: 16),
                  Icon(Icons.play_circle_outline, color: Colors.deepPurple),
                  SizedBox(width: 6),
                  Text("Recorded input", style: TextStyle(color: Colors.black54)),
                ],
              ),
              const SizedBox(height: 24),
              // Request Help Button
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: (_nameController.text.trim().isNotEmpty &&
                          _ageController.text.trim().isNotEmpty &&
                          _phoneController.text.trim().isNotEmpty)
                      ? () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const MapPage()),
                          );
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    foregroundColor: Colors.white,
                    elevation: (_nameController.text.trim().isNotEmpty &&
                            _ageController.text.trim().isNotEmpty &&
                            _phoneController.text.trim().isNotEmpty)
                        ? 2
                        : 0,
                  ),
                  child: const Text("Request Help", style: TextStyle(fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 