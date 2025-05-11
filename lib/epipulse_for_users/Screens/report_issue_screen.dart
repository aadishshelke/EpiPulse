import 'package:flutter/material.dart';
import 'dart:io';

class ReportIssueScreen extends StatefulWidget {
  const ReportIssueScreen({Key? key}) : super(key: key);

  @override
  State<ReportIssueScreen> createState() => _ReportIssueScreenState();
}

class _ReportIssueScreenState extends State<ReportIssueScreen> {
  String? photoPath;
  final TextEditingController _descController = TextEditingController();
  String location = "Auto-filled location";
  bool submitted = false;

  void submitReport() {
    setState(() {
      submitted = true;
    });
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (submitted) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.check_circle, color: Colors.green, size: 60),
              SizedBox(height: 16),
              Text('✔️ Thanks! Your report has been submitted.', style: TextStyle(fontSize: 18)),
            ],
          ),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(title: const Text('Report Water Issue')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Attach a photo', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () {}, // TODO: Implement photo picker
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey),
                ),
                child: photoPath == null
                    ? const Icon(Icons.camera_alt, size: 40, color: Colors.grey)
                    : Image.file(
                        File(photoPath!),
                        fit: BoxFit.cover,
                      ),
              ),
            ),
            const SizedBox(height: 20),
            const Text('Describe the issue', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextField(
              controller: _descController,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: 'Describe the issue here...'
              ),
            ),
            const SizedBox(height: 20),
            const Text('Location', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.location_on, color: Colors.blue),
                const SizedBox(width: 8),
                Expanded(child: Text(location)),
                TextButton(
                  onPressed: () {}, // TODO: Implement manual override
                  child: const Text('Edit'),
                ),
              ],
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: submitReport,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                child: const Text('Submit Report'),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 