import 'package:flutter/material.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:permission_handler/permission_handler.dart';

const String agoraAppId = 'e383b8c5e7be455fa1056bdc21e2a498'; // User's Agora App ID
const String channelName = 'test_channel'; // You can make this dynamic

class VideoCallScreen extends StatefulWidget {
  final String channel;
  const VideoCallScreen({Key? key, required this.channel}) : super(key: key);

  @override
  State<VideoCallScreen> createState() => _VideoCallScreenState();
}

class _VideoCallScreenState extends State<VideoCallScreen> {
  int? _remoteUid;
  late RtcEngine _engine;
  bool _isEngineReady = false;
  bool _isMuted = false;
  bool _isCameraOff = false;

  @override
  void initState() {
    super.initState();
    initAgora();
  }

  Future<void> initAgora() async {
    // Request permissions first
    Map<Permission, PermissionStatus> statuses = await [
      Permission.microphone,
      Permission.camera,
    ].request();

    // Check if permissions are granted
    if (statuses[Permission.microphone] != PermissionStatus.granted ||
        statuses[Permission.camera] != PermissionStatus.granted) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Camera and microphone permissions are required for video calls'),
          ),
        );
        Navigator.pop(context);
        return;
      }
    }

    try {
      _engine = createAgoraRtcEngine();
      await _engine.initialize(RtcEngineContext(
        appId: agoraAppId,
        channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
      ));

      _engine.registerEventHandler(
        RtcEngineEventHandler(
          onJoinChannelSuccess: (connection, elapsed) {
            print('Local user joined');
          },
          onUserJoined: (connection, remoteUid, elapsed) {
            setState(() {
              _remoteUid = remoteUid;
            });
          },
          onUserOffline: (connection, remoteUid, reason) {
            setState(() {
              _remoteUid = null;
            });
          },
          onError: (err, msg) {
            print('Error: $err, $msg');
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error: $msg')),
              );
            }
          },
        ),
      );

      await _engine.enableVideo();
      await _engine.enableAudio();
      await _engine.startPreview();
      await _engine.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
      
      await _engine.joinChannel(
        token: '', // Empty string for testing with App ID only
        channelId: widget.channel,
        uid: 0,
        options: const ChannelMediaOptions(
          clientRoleType: ClientRoleType.clientRoleBroadcaster,
          channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
        ),
      );

      setState(() {
        _isEngineReady = true;
      });
    } catch (e) {
      print('Error initializing Agora: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error initializing video call: $e')),
        );
        Navigator.pop(context);
      }
    }
  }

  void _onToggleMute() {
    setState(() {
      _isMuted = !_isMuted;
    });
    _engine.muteLocalAudioStream(_isMuted);
  }

  void _onToggleCamera() {
    setState(() {
      _isCameraOff = !_isCameraOff;
    });
    _engine.muteLocalVideoStream(_isCameraOff);
  }

  @override
  void dispose() {
    if (_isEngineReady) {
      _engine.leaveChannel();
      _engine.release();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isEngineReady) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Video Call'),
        leading: IconButton(
          icon: const Icon(Icons.call_end, color: Colors.red),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          Center(
            child: _remoteUid != null
                ? AgoraVideoView(
                    controller: VideoViewController.remote(
                      rtcEngine: _engine,
                      canvas: VideoCanvas(uid: _remoteUid),
                      connection: RtcConnection(channelId: widget.channel),
                    ),
                  )
                : const Text('Waiting for remote user...'),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Container(
              width: 120,
              height: 160,
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: AgoraVideoView(
                  controller: VideoViewController(
                    rtcEngine: _engine,
                    canvas: const VideoCanvas(uid: 0),
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 25.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RawMaterialButton(
                    onPressed: _onToggleMute,
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(12.0),
                    fillColor: _isMuted ? Colors.red : Colors.white,
                    child: Icon(
                      _isMuted ? Icons.mic_off : Icons.mic,
                      color: _isMuted ? Colors.white : Colors.black,
                      size: 20.0,
                    ),
                  ),
                  RawMaterialButton(
                    onPressed: () => Navigator.pop(context),
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(15.0),
                    fillColor: Colors.red,
                    child: const Icon(
                      Icons.call_end,
                      color: Colors.white,
                      size: 35.0,
                    ),
                  ),
                  RawMaterialButton(
                    onPressed: _onToggleCamera,
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(12.0),
                    fillColor: _isCameraOff ? Colors.red : Colors.white,
                    child: Icon(
                      _isCameraOff ? Icons.videocam_off : Icons.videocam,
                      color: _isCameraOff ? Colors.white : Colors.black,
                      size: 20.0,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
} 