import 'dart:async';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import '../utils/settings.dart';

class CallPage extends StatefulWidget {
  // non-modifiable channel name of the page
  final String channelName;

  /// non-modifiable client role of the page
  final ClientRole role;

  /// Creates a call page with given channel name.
  const CallPage({Key key, this.channelName, this.role}) : super(key: key);

  @override
  _CallPageState createState() => _CallPageState();
}

class _CallPageState extends State<CallPage> {
  bool muted = false;
  static final _users = <int>[];

  // final _infoStrings = <String>[];

  @override
  void dispose() {
    // clear users
    _users.clear();

    // destroy sdk
    AgoraRtcEngine.leaveChannel();
    AgoraRtcEngine.destroy();

    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    // initialize agora sdk
    initialize();
  }

  Future<void> initialize() async {
    if (APP_ID.isEmpty) {
      /*setState(() {
        _infoStrings.add('APP_ID missing, please provide your APP_ID in settings.dart');
        _infoStrings.add('Agora Engine is not starting');
      });*/
      return;
    }

    await _initAgoraRtcEngine();
    _addAgoraEventHandlers();
    await AgoraRtcEngine.enableWebSdkInteroperability(true);
    VideoEncoderConfiguration configuration = VideoEncoderConfiguration();
    configuration.dimensions = Size(1920, 1080);
    await AgoraRtcEngine.setVideoEncoderConfiguration(configuration);
    await AgoraRtcEngine.joinChannel(null, widget.channelName, null, 0);
  }

  /// Create agora sdk instance and initialize
  Future<void> _initAgoraRtcEngine() async {
    await AgoraRtcEngine.create(APP_ID);
    await AgoraRtcEngine.enableVideo();
    await AgoraRtcEngine.setChannelProfile(ChannelProfile.Communication);
    await AgoraRtcEngine.setClientRole(widget.role);
  }

  // Add agora event handlers
  void _addAgoraEventHandlers() {
    AgoraRtcEngine.onError = (dynamic code) {
      setState(() {
        // final info = 'onError: $code';
        // _infoStrings.add(info);
      });
    };

    AgoraRtcEngine.onJoinChannelSuccess = (String channel, int uid, int elapsed) {
      setState(() {
        // final info = 'onJoinChannel: $channel, uid: $uid';
        // _infoStrings.add(info);
      });
    };

    AgoraRtcEngine.onLeaveChannel = () {
      setState(() {
        // _infoStrings.add('onLeaveChannel');
        _users.clear();
      });
    };

    AgoraRtcEngine.onUserJoined = (int uid, int elapsed) {
      setState(() {
        // final info = 'userJoined: $uid';
        // _infoStrings.add(info);
        _users.add(uid);
      });
    };

    AgoraRtcEngine.onUserOffline = (int uid, int reason) {
      setState(() {
        // final info = 'userOffline: $uid';
        // _infoStrings.add(info);
        _users.remove(uid);
      });
    };

    AgoraRtcEngine.onFirstRemoteVideoFrame = (int uid, int width, int height, int elapsed) {
      setState(() {
        // final info = 'firstRemoteVideo: $uid ${width}x $height';
        // _infoStrings.add(info);
      });
    };
  }

  // Helper function to get list of native views
  List<Widget> _getRenderViews() {
    final List<AgoraRenderWidget> list = [AgoraRenderWidget(0, local: true, preview: true)];
    _users.forEach((int uid) => list.add(AgoraRenderWidget(uid)));

    return list;
  }

  // Video view wrapper
  Widget _videoView(view) {
    return Expanded(child: Container(child: view));
  }

  // Video view row wrapper
  Widget _expandedVideoRow(List<Widget> views) {
    final wrappedViews = views.map<Widget>(_videoView).toList();

    return Row(children: wrappedViews);
    // return Expanded(child: Row(children: wrappedViews));
  }

  // Video layout wrapper
  Widget _viewRows(_width, _height) {
    final views = _getRenderViews();

    switch (views.length) {
      case 1:
        return Container(child: Column(children: <Widget>[_videoView(views[0])]));

      case 2:
        return Container(
          child: Stack(
            children: <Widget>[
              // _expandedVideoRow([views[0]]),
              _expandedVideoRow([views[1]]),
              Positioned(
                top: 10,
                right: 10,
                child: Container(
                  width: _width * 0.35,
                  height: _height * 0.20,
                  child: Material(
                    elevation: 4,
                    type: MaterialType.card,
                    clipBehavior: Clip.antiAlias,
                    child: _expandedVideoRow([views[0]]),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ],
          ),
        );

      case 3:
        return Container(
          child: Column(
            children: <Widget>[_expandedVideoRow(views.sublist(0, 2)), _expandedVideoRow(views.sublist(2, 3))],
          ),
        );

      case 4:
        return Container(
          child: Column(
            children: <Widget>[_expandedVideoRow(views.sublist(0, 2)), _expandedVideoRow(views.sublist(2, 4))],
          ),
        );

      default:
    }

    return Container();
  }

  /// Toolbar layout
  Widget _toolbar() {
    return Container(
      alignment: Alignment.bottomCenter,
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          RawMaterialButton(
            elevation: 2.0,
            shape: CircleBorder(),
            onPressed: _onToggleMute,
            padding: const EdgeInsets.all(12.0),
            fillColor: muted ? Colors.blueAccent : Colors.white,
            child: Icon(muted ? Icons.mic_off : Icons.mic, size: 20.0, color: muted ? Colors.white : Colors.blueAccent),
          ),
          RawMaterialButton(
            elevation: 2.0,
            shape: CircleBorder(),
            fillColor: Colors.redAccent,
            padding: const EdgeInsets.all(15.0),
            onPressed: () => _onCallEnd(context),
            child: Icon(Icons.call_end, size: 35.0, color: Colors.white),
          ),
          RawMaterialButton(
            elevation: 2.0,
            shape: CircleBorder(),
            fillColor: Colors.white,
            onPressed: _onSwitchCamera,
            padding: const EdgeInsets.all(12.0),
            child: Icon(Icons.switch_camera, size: 20.0, color: Colors.blueAccent),
          ),
        ],
      ),
    );
  }

  /// Info panel to show logs
  Widget _panel() {
    return Container(
      alignment: Alignment.bottomCenter,
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: FractionallySizedBox(
        heightFactor: 0.5,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 48),
          /*child: ListView.builder(
            reverse: true,
            itemCount: _infoStrings.length,
            itemBuilder: (BuildContext context, int index) {
              if (_infoStrings.isEmpty) {
                return null;
              }

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 10),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 5),
                        child: Text(_infoStrings[index], style: TextStyle(color: Colors.blueGrey)),
                        decoration: BoxDecoration(color: Colors.yellowAccent, borderRadius: BorderRadius.circular(5)),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),*/
        ),
      ),
    );
  }

  void _onCallEnd(BuildContext context) {
    Navigator.pop(context);
  }

  void _onToggleMute() {
    setState(() {
      muted = !muted;
    });

    AgoraRtcEngine.muteLocalAudioStream(muted);
  }

  void _onSwitchCamera() {
    AgoraRtcEngine.switchCamera();
  }

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(title: Text('Agora Flutter QuickStart')),
      body: Center(child: Stack(children: <Widget>[_viewRows(_width, _height), _panel(), _toolbar()])),
    );
  }
}
