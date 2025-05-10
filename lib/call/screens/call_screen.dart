import 'package:flutter/material.dart';
import 'package:epipulse/call/repository/call_repository.dart';

class CallScreen extends StatefulWidget {
  final String channelId;
  final String hospitalUid;
  final String patientUid;
  const CallScreen({
    super.key,
    required this.channelId,
    required this.hospitalUid,
    required this.patientUid,
  });

  @override
  State<StatefulWidget> createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Video Call'),
        leading: IconButton(
          icon: const Icon(Icons.call_end, color: Colors.red),
          onPressed: () {
            endCall(
              context: context,
              patientUid: widget.patientUid,
              hospitalUid: widget.hospitalUid,
            );
          },
        ),
      ),
      body: const Center(
        child: Text(
          'Video call functionality is temporarily disabled.\nPlease check back later.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
