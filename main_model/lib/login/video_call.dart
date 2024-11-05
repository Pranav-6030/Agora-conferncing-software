import 'dart:convert';
import 'dart:async';
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
  bool _showVideo = true; // Set to true to display immediately
  String tToken = "";
  int remoteUserCount = 0;
  bool isSingleUser = true; // Flag for single user layout
  bool isHandRaised = false;
  bool isLiked = false;

  @override
  void initState() {
    super.initState();
    getToken();
  }

  Future<void> getToken() async {
    String link =
        "https://2b220ff3-a521-42cb-84c7-1077e3490399-00-30xo35cwxoeoi.pike.replit.dev/access_token?channelName=${widget.channelName}";

    try {
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
              setState(() {
                remoteUserCount++;
                isSingleUser = false;
                _showVideo = true;
              });
            },
            onFirstRemoteVideoFrame: (RtcConnection connection, int uid, int width, int height, int elapsed) {
              print("First video frame received from remote user with uid: $uid");
              setState(() {
                _showVideo = true;
              });
            },
            onUserOffline: (RtcConnection connection, int uid, UserOfflineReasonType reason) {
              print("User with uid $uid went offline for reason: $reason");
              setState(() {
                remoteUserCount--;
                isSingleUser = remoteUserCount == 0; // Set to single user layout if no remote users
              });
            },
          ),
        );

        await _client.initialize();

        // Mute the microphone after initializing the Agora client
        await _client.engine.muteLocalAudioStream(true);

        print("Agora client initialized and microphone muted.");
        setState(() => _loading = false);
      } else {
        print("Failed to fetch token: ${_response.statusCode}");
        setState(() => _loading = false);
      }
    } catch (e) {
      print("Error fetching token: $e");
      setState(() => _loading = false);
    }
  }

  void toggleHandRaise() {
    setState(() {
      isHandRaised = !isHandRaised;
    });
    print("Hand raise status: $isHandRaised");
  }

  void toggleLike() {
    setState(() {
      isLiked = !isLiked;
    });
    print("Like status: $isLiked");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _loading
            ? Center(child: CircularProgressIndicator())
            : Stack(
                children: [
                  if (tToken.isNotEmpty && _showVideo)
                    AgoraVideoViewer(
                      client: _client,
                      layoutType: isSingleUser ? Layout.floating : Layout.grid,
                    ),
                  if (tToken.isNotEmpty)
                    AgoraVideoButtons(client: _client),
                  // Custom Hand Raise Button
                  Positioned(
                    bottom: 100,
                    right: 15,
                    child: FloatingActionButton.small(
                      onPressed: toggleHandRaise,
                      backgroundColor: Colors.blue,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 5),
                        child: Icon(
                          Icons.pan_tool,
                          color: isHandRaised ? Colors.yellow : Colors.white,
                        ),
                      ),
                    ),
                  ),
                  // Custom Like Button
                  Positioned(
                    bottom: 100,
                    left: 15,
                    child: FloatingActionButton.small(
                      onPressed: toggleLike,
                      backgroundColor: Colors.blue,
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Icon(
                          Icons.thumb_up,
                          color: isLiked ? Colors.yellow : Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
