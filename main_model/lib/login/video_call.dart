import 'package:flutter/material.dart';
import 'package:agora_uikit/agora_uikit.dart';

class VideoCall extends StatefulWidget {
  @override
  _VideoCallState createState() => _VideoCallState();
}

class _VideoCallState extends State<VideoCall> {
  final AgoraClient _client = AgoraClient(
    agoraConnectionData: AgoraConnectionData(
      channelName: 'test',
      appId: "062422fdc96a41a69c6ffbf360cdd9ee",
      tokenUrl:"https://c0f2dc5b-b3fc-4698-a0f0-9960ecb62e5c-00-1vhen0qfpmz06.pike.replit.dev/access_token?channelName=test",
    ),
    enabledPermission: [
      Permission.camera,
      Permission.microphone,
    ],
  );

  @override
  void initState() {
    super.initState();
    _client.initialize().then((_) {
      print("Agora client initialized");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            AgoraVideoViewer(client: _client),
            AgoraVideoButtons(client: _client),
          ],
        ),
      ),
    );
  }
}
