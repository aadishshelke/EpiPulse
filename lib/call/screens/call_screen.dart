import 'package:agora_uikit/agora_uikit.dart';
import 'package:emedoc/agora_config.dart';
import 'package:emedoc/call/repository/call_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
  FirebaseAuth auth = FirebaseAuth.instance;
  AgoraClient? client;
  String baseUrl = 'https://whatsapp-clone-rrr.herokuapp.com';

  @override
  void initState() {
    super.initState();
    client = AgoraClient(
      agoraConnectionData: AgoraConnectionData(
        appId: AgoraConfig.appId,
        channelName: widget.channelId,
        tokenUrl: baseUrl,
      ),
    );
    initAgora();
  }

  void initAgora() async {
    await client!.initialize();
  }

  @override
  Widget build(BuildContext context) {
    if (client == null) {
      return const Scaffold(
        body: Center(
          child: Text('Loading...'),
        ),
      );
    }
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            AgoraVideoViewer(client: client!),
            AgoraVideoButtons(
              client: client!,
              disconnectButtonChild: ElevatedButton(
                onPressed: () async {
                  await client!.engine.leaveChannel();
                  if (context.mounted) {
                    endCall(
                      context: context,
                      patientUid: widget.patientUid,
                      hospitalUid: widget.hospitalUid,
                    );
                  }
                },
                child: const Icon(
                  Icons.call_end,
                  color: Colors.red,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
