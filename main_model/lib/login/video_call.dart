import 'dart:convert';
import 'dart:async'; // For Timer
import 'package:flutter/material.dart';
import 'package:agora_uikit/agora_uikit.dart';
import 'package:http/http.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';

class VideoCall extends StatefulWidget {
  final String channelName;

  VideoCall({Key? key, required this.channelName}) : super(key: key);

  @override
  State<VideoCall> createState() => _VideoCallState();
}

class _VideoCallState extends State<VideoCall> {
  late AgoraClient _client;
  bool _loading = true;
  bool _showVideo = false; // New variable to control video rendering
  String tToken = "";

  @override
  void initState() {
    super.initState();
    getToken();
  }

  Future<void> getToken() async {
    String link =
        "https://c0f2dc5b-b3fc-4698-a0f0-9960ecb62e5c-00-1vhen0qfpmz06.pike.replit.dev/access_token?channelName=${widget.channelName}";

    Response _response = await get(Uri.parse(link));

    if (_response.statusCode == 200) {
      Map data = jsonDecode(_response.body);
      print("Token fetched: ${data["token"]}");
      setState(() {
        tToken = data["token"];
      });

      _client = AgoraClient(
        agoraConnectionData: AgoraConnectionData(
          appId: "27c52a63ee6a4757b5aa4cb497683fe8",
          channelName: widget.channelName,
          tempToken: tToken,
        ),
        enabledPermission: [
          Permission.camera,
          Permission.microphone,
        ],
        agoraEventHandlers: AgoraRtcEventHandlers(
          onUserJoined: (RtcConnection connection, int uid, int elapsed) {
            print("Remote user joined with uid: $uid");
            if (uid != null && uid != 0) {
              setState(() {
                // Delay rendering video for 2 seconds to ensure everything is ready
                Timer(Duration(seconds: 2), () {
                  setState(() {
                    _showVideo = true; // Set to true after delay
                  });
                });
              });
            }
          },
          onFirstRemoteVideoFrame: (RtcConnection connection, int uid, int width, int height, int elapsed) {
            print("First video frame received from remote user with uid: $uid");
            if (uid != null && uid != 0) {
              setState(() {
                _showVideo = true;
              });
            }
          },
          onUserOffline: (RtcConnection connection, int uid, UserOfflineReasonType reason) {
            print("User with uid $uid went offline for reason: $reason");
          },
        ),
      );

      await _client.initialize();
      setState(() => _loading = false);
    } else {
      print("Failed to fetch token: ${_response.statusCode}");
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _loading
            ? Center(child: CircularProgressIndicator())
            : Stack(
                children: [
                  if (!_loading && tToken.isNotEmpty && _showVideo) // Check for _showVideo before rendering
                    AgoraVideoViewer(
                      client: _client,
                      layoutType: Layout.grid,
                    ),
                  if (!_loading && tToken.isNotEmpty)
                    AgoraVideoButtons(client: _client),
                ],
              ),
      ),
    );
  }
}
