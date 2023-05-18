import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:agora_rtc_engine/rtc_local_view.dart' as rtc_local_view;
import 'package:agora_rtc_engine/rtc_remote_view.dart' as rtc_remote_view;
import 'package:bukmd_telemedicine/src/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
// import 'package:http/http.dart' as http;
import '../../wrappers/auth_wrapper.dart';

const appId = '6091feca46a246fe88be7cbbf11cce77';
const token =
    '007eJxTYJhZmS61fGdUZuHFUv3p+RIXvmv2zlE88HFyOpOa689v0eUKDGYGloZpqcmJJmaJRiZmaakWFkmp5slJSWmGhsnJqebmSjvTUhoCGRm2TatjYIRCEF+IIak0OzclPjk/r7g0pySxJDM/j4EBAHNHJlM=';
const channel = 'bukmd_consultation';

class CallScreen extends ConsumerStatefulWidget {
  const CallScreen({Key? key, this.isDoctor = true}) : super(key: key);
  final bool isDoctor;
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CallScreenState();
}

class _CallScreenState extends ConsumerState<CallScreen> {
  // Future<void> getToken() async {
  //   final response = await http.get(
  //     Uri.parse(baseUrl + '/rtc/' + channel + '/publisher/uid/' + appId
  //         // To add expiry time uncomment the below given line with the time in seconds
  //         // + '?expiry=45'
  //         ),
  //   );

  //   if (response.statusCode == 200) {
  //     setState(() {
  //       token = response.body;
  //       token = jsonDecode(token)['rtcToken'];
  //     });
  //   } else {
  //     print('Failed to fetch the token');
  //   }
  // }

  int? _remoteUid;
  late RtcEngine? _engine;
  bool muted = true;
  bool _localUserJoined = false;
  bool _endCall = false;

  @override
  void initState() {
    super.initState();
    initAgora();
  }

  @override
  void dispose() {
    _engine?.leaveChannel();
    _engine?.destroy();
    super.dispose();
  }

  Future<void> askPermission() async {}

  Future<void> initAgora() async {
    // retrieve permissions
    Map<Permission, PermissionStatus> statuses =
        await [Permission.microphone, Permission.camera].request();

    if (statuses[Permission.microphone] == PermissionStatus.denied ||
        statuses[Permission.camera] == PermissionStatus.denied) {
      _engine = null;
      if (!mounted) return;
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const AuthWrapper()),
          (Route<dynamic> route) => false);
    }

    //create the engine
    _engine = await RtcEngine.create(appId);
    await _engine?.enableVideo();
    _engine?.setEventHandler(
      RtcEngineEventHandler(
        joinChannelSuccess: (String channel, int uid, int elapsed) {
          print("local user $uid joined");

          setState(() {
            _localUserJoined = true;
          });
        },
        userJoined: (int uid, int elapsed) {
          print("remote user $uid joined");
          setState(() {
            _remoteUid = uid;
          });
        },
        userOffline: (int uid, UserOfflineReason reason) {
          print("remote user $uid left channel");

          setState(() {
            _remoteUid = null;
          });
        },
      ),
    );
    try {
      await _engine?.joinChannel(token, channel, null, 0);
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        widget.isDoctor
            ? await showDialog(
                context: context,
                builder: (BuildContext context) {
                  return doctorEndCallAlert(context);
                },
              )
            : await await showDialog(
                context: context,
                builder: (BuildContext context) {
                  return patientEndCallAlert(context);
                },
              );
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: Center(
            child: Stack(
              children: [
                Center(
                  child: _remoteVideo(widget.isDoctor),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: _localUserJoined
                        ? SizedBox(
                            width: 120,
                            height: 160,
                            child: Center(
                              child: _renderLocalPreview(),
                            ))
                        : const SizedBox(
                            width: 120,
                            height: 160,
                            child: Center(
                              child: SizedBox(
                                  height: 32,
                                  width: 32,
                                  child: Center(
                                      child: CircularProgressIndicator())),
                            )),
                  ),
                ),
                _toolbar()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _remoteVideo(bool isDoctor) {
    if (_remoteUid != null) {
      return rtc_remote_view.SurfaceView(
        uid: _remoteUid!,
        channelId: channel,
      );
    } else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Center(child: CircularProgressIndicator()),
          const SizedBox(
            height: 16,
          ),
          Text(
            isDoctor
                ? 'Please wait for the patient to join...'
                : 'Please wait for the doctor to join...',
            style: const TextStyle(color: Colors.white),
            textAlign: TextAlign.center,
          ),
        ],
      );
    }
  }

  Widget _renderLocalPreview() {
    if (_localUserJoined) {
      return const rtc_local_view.SurfaceView();
    } else {
      return const Text(
        'Joining Channel, Please wait.....',
        textAlign: TextAlign.center,
      );
    }
  }

  Widget _toolbar() => Container(
        alignment: Alignment.bottomCenter,
        padding: const EdgeInsets.symmetric(vertical: 48),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RawMaterialButton(
              onPressed: () {
                setState(() {
                  muted = !muted;
                });
                _engine?.muteLocalAudioStream(muted);
              },
              shape: const CircleBorder(),
              elevation: 2.0,
              fillColor: muted ? Colors.blueAccent : Colors.white,
              padding: const EdgeInsets.all(12.0),
              child: Icon(
                muted ? Icons.mic_off : Icons.mic,
                color: muted ? Colors.white : Colors.blueAccent,
                size: 20.0,
              ),
            ),
            RawMaterialButton(
              onPressed: () async {
                setState(() {
                  muted = true;
                });
                widget.isDoctor
                    ? await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return doctorEndCallAlert(context);
                        },
                      )
                    : await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return patientEndCallAlert(context);
                        },
                      );
                if (!mounted) return;
                _endCall ? Navigator.pop(context) : null;
              },
              shape: const CircleBorder(),
              elevation: 2.0,
              fillColor: Colors.redAccent,
              padding: const EdgeInsets.all(15.0),
              child: const Icon(
                Icons.call_end,
                color: Colors.white,
                size: 35.0,
              ),
            ),
            RawMaterialButton(
              onPressed: () => _engine?.switchCamera(),
              shape: const CircleBorder(),
              elevation: 2.0,
              fillColor: Colors.white,
              padding: const EdgeInsets.all(12.0),
              child: const Icon(
                Icons.switch_camera,
                color: Colors.blueAccent,
                size: 20.0,
              ),
            ),
          ],
        ),
      );

  doctorEndCallAlert(BuildContext context) => AlertDialog(
        title: const Text(
          'Create e-Prescription?',
          style: TextStyle(fontWeight: FontWeight.w500, color: primaryColor),
        ),
        backgroundColor: Colors.white,
        titleTextStyle: const TextStyle(fontSize: 16.0, color: Colors.black),
        titlePadding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
        actions: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: () {
                  setState(() {
                    _endCall = true;
                  });
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AuthWrapper()),
                      (Route<dynamic> route) => false);
                },
                child: const Text(
                  'Exit',
                  style: TextStyle(color: Colors.red),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(context,
                      '/create-prescription', (Route<dynamic> route) => false);
                },
                child: const Text('Yes', style: TextStyle(color: Colors.green)),
              )
            ],
          ),
        ],
      );

  patientEndCallAlert(BuildContext context) => AlertDialog(
        title: const Text(
          'End call?',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        titleTextStyle: const TextStyle(fontSize: 16.0, color: Colors.black),
        titlePadding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text(
              'No',
            ),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _endCall = true;
              });
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const AuthWrapper()),
                  (Route<dynamic> route) => false);
            },
            child: const Text(
              'Yes',
            ),
          ),
        ],
      );
}
