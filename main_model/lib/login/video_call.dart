import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:agora_uikit/agora_uikit.dart';
import 'package:http/http.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';

class VideoCall extends StatefulWidget {
  final String channelName;
  final int? countTimer;

  const VideoCall({Key? key, required this.channelName, this.countTimer = 30}) : super(key: key);

  @override
  State<VideoCall> createState() => _VideoCallState();
}

class _VideoCallState extends State<VideoCall> {
  late AgoraClient _client;
  bool _loading = true;
  bool _showVideo = true;
  String tToken = "";
  int remoteUserCount = 0;
  bool isSingleUser = true;
  bool isHandRaised = false;
  bool isLiked = false;
  bool hasUnmutePermission = false;
  int countdown = 0; // Countdown in seconds
  Timer? countdownTimer;

  @override
  void initState() {
    super.initState();
    getToken();
  }

  Future<void> getToken() async {
    String link =
        "https://0fd0b867-eaa0-40d2-aff9-d933e73b5bd2-00-1fpe7al99i7ye.pike.replit.dev/access_token?channelName=${widget.channelName}";

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
                isSingleUser = remoteUserCount == 0;
              });
            },
          ),
        );

        await _client.initialize();
        print("Agora client initialized.");
        await _client.engine.muteLocalAudioStream(true);
        print("Mic muted");
        _client.sessionController.value = _client.sessionController.value.copyWith(
          isLocalUserMuted: true,
        );

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

  void toggleUnmutePermission() {
    setState(() {
      hasUnmutePermission = !hasUnmutePermission;
    });

    if (hasUnmutePermission) {
      // Show a message when permission is granted
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("You have permission")),
      );

      // Start the countdown at 30 seconds
      countdown = widget.CountTimer ?? 30;

      // Start a periodic timer to update countdown every second
      countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          countdown--;
        });

        if (countdown <= 0) {
          // When countdown finishes, revoke permission and stop the timer
          revokePermission();
          countdownTimer?.cancel();
        }
      });
    } else {
      // Manually revoke permission and stop the timer
      revokePermission();
    }

    print("Unmute permission: $hasUnmutePermission");
  }

  void revokePermission() {
    setState(() {
      hasUnmutePermission = false;
      countdown = 0; // Reset countdown to hide it
    });

    // Mute the user if they're currently unmuted
    if (!_client.sessionController.value.isLocalUserMuted) {
      _client.sessionController.value = _client.sessionController.value.copyWith(
        isLocalUserMuted: true,
      );
      _client.engine.muteLocalAudioStream(true);
    }

    // Show "Times up buddy" message when permission is revoked
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Times up buddy")),
    );

    print("Permission automatically revoked. Mic muted if needed.");
  }

  void handleMicToggle() {
    if (!hasUnmutePermission && _client.sessionController.value.isLocalUserMuted == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("You have no permission")),
      );
    } else {
      bool newMuteState = !_client.sessionController.value.isLocalUserMuted;
      _client.sessionController.value = _client.sessionController.value.copyWith(
        isLocalUserMuted: newMuteState,
      );
      _client.engine.muteLocalAudioStream(newMuteState);
      setState(() {
        print("Mic toggled. Muted: $newMuteState");
      });
    }
  }

  @override
  void dispose() {
    countdownTimer?.cancel(); // Cancel timer if still running
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : Stack(
                children: [
                                    if (tToken.isNotEmpty && _showVideo)
                    remoteUserCount == 1
                        ? AgoraVideoViewer(
                            client: _client,
                            layoutType: Layout.floating, // Single user with floating layout
                          )
                        : remoteUserCount > 4
                            ? SingleChildScrollView(
                                child: GridView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2, // You can change the number of columns
                                    crossAxisSpacing: 10,
                                    mainAxisSpacing: 10,
                                  ),
                                  itemCount: remoteUserCount + 1, // including local user
                                  itemBuilder: (context, index) {
                                    return Container(
                                      padding: EdgeInsets.all(8),
                                      child: AgoraVideoViewer(
                                        client: _client,
                                        layoutType: Layout.grid,
                                      ),
                                    );
                                  },
                                ),
                              )
                            : AgoraVideoViewer(
                                client: _client,
                                layoutType: Layout.grid, // Default grid layout for 2-4 users
                              ),
                  if (tToken.isNotEmpty)
                    AgoraVideoButtons(
                      client: _client,
                      enabledButtons: const [
                        BuiltInButtons.callEnd,
                        BuiltInButtons.switchCamera,
                        BuiltInButtons.toggleCamera,
                      ],
                      extraButtons: [
                        SizedBox(
                          height: 45,
                          width: 45,
                          child: FloatingActionButton(
                            onPressed: handleMicToggle,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(100)
                            ),
                            child: Icon(
                              _client.sessionController.value.isLocalUserMuted
                                  ? Icons.mic_off
                                  : Icons.mic,
                            ),
                          ),
                        ),
                      ],
                    ),
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
                  Positioned(
                    bottom: 300,
                    left: 15,
                    child: FloatingActionButton.small(
                      onPressed: toggleUnmutePermission,
                      backgroundColor: Colors.blue,
                      child: Icon(
                        Icons.perm_camera_mic,
                        color: hasUnmutePermission ? Colors.yellow : Colors.white,
                      ),
                    ),
                  ),
                  // Display countdown if permission is active
                  if (hasUnmutePermission)
                    Positioned(
                      bottom: 350,
                      left: 20,
                      child: Text(
                        "Time left: $countdown s",
                        style: const TextStyle(fontSize: 18, color: Colors.red),
                      ),
                    ),
                ],
              ),
      ),
    );
  }
}
