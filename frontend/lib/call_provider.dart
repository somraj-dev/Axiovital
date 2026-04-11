import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'call_screen.dart';
enum CallStatus { none, dialing, ringing, connecting, active, muted, ended, unavailable }
enum CallType { doctor, clinic, friend, community, group }

class CallParticipant {
  final String id;
  final String name;
  final String avatarUrl;
  final String role;
  bool isMuted;
  bool isSpeaking;

  CallParticipant({
    required this.id,
    required this.name,
    required this.avatarUrl,
    required this.role,
    this.isMuted = false,
    this.isSpeaking = false,
  });
}

class CallSession {
  final String sessionId;
  final CallType type;
  final CallParticipant target;
  DateTime? startedAt;
  Duration duration;

  CallSession({
    required this.sessionId,
    required this.type,
    required this.target,
    this.startedAt,
    this.duration = Duration.zero,
  });
}

class CallProvider extends ChangeNotifier {
  CallStatus _status = CallStatus.none;
  CallStatus get status => _status;

  CallSession? _currentSession;
  CallSession? get currentSession => _currentSession;
  
  bool _isMuted = false;
  bool get isMuted => _isMuted;

  bool _isSpeakerOn = false;
  bool get isSpeakerOn => _isSpeakerOn;

  Timer? _durationTimer;
  Timer? _simulatedNetworkTimer;

  // WebRTC Interface Hooks (Structure required for actual WebRTC signaling integration)
  // RTCVideoRenderer? _localRenderer;
  // RTCVideoRenderer? _remoteRenderer;
  // RTCPeerConnection? _peerConnection;

  void startOutgoingCall(BuildContext context, CallParticipant target, CallType type) {
    // 1. Initial State
    _status = CallStatus.dialing;
    _currentSession = CallSession(
      sessionId: 'call_${DateTime.now().millisecondsSinceEpoch}',
      type: type,
      target: target,
    );
    notifyListeners();

    // Open UI
    Navigator.push(context, MaterialPageRoute(builder: (context) => const CallScreen()));

    // 2. WebRTC Signaling Simulation: Dialing -> Ringing
    _simulatedNetworkTimer = Timer(const Duration(seconds: 2), () {
      if (_status == CallStatus.dialing) {
        _status = CallStatus.ringing;
        notifyListeners();

        // 3. Simulated Connection Success after ringing
        _simulatedNetworkTimer = Timer(const Duration(seconds: 3), () {
          if (_status == CallStatus.ringing) {
            _handleCallConnected();
          }
        });
      }
    });
  }

  void _handleCallConnected() {
    _status = CallStatus.connecting;
    notifyListeners();

    // Pretend ICE candidates negotiated 
    Future.delayed(const Duration(milliseconds: 800), () {
      if (_status != CallStatus.ended) {
        _status = CallStatus.active;
        _currentSession?.startedAt = DateTime.now();
        _startTimer();
        notifyListeners();
      }
    });
  }

  void handleIncomingCall(CallParticipant caller) {
    _status = CallStatus.ringing;
    // Logic to show incoming call sheet/notification
    notifyListeners();
  }

  void acceptIncomingCall() {
    _handleCallConnected();
  }

  void declineIncomingCall() {
    endCall();
  }

  void toggleMute() {
    _isMuted = !_isMuted;
    notifyListeners();
    // WebRTC: _localStream?.getAudioTracks()[0].enabled = !_isMuted;
  }

  void toggleSpeaker() {
    _isSpeakerOn = !_isSpeakerOn;
    notifyListeners();
    // Hardware bridge adjustment
  }

  void endCall() {
    _status = CallStatus.ended;
    _durationTimer?.cancel();
    _simulatedNetworkTimer?.cancel();
    notifyListeners();

    // WebRTC: close peer connection and dispose renderers

    // Auto cleanup after showing 'Call Ended' screen briefly
    Future.delayed(const Duration(seconds: 2), () {
      _status = CallStatus.none;
      _currentSession = null;
      _isMuted = false;
      _isSpeakerOn = false;
      notifyListeners();
    });
  }

  void _startTimer() {
    _durationTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_currentSession != null && _status == CallStatus.active) {
        _currentSession!.duration = Duration(seconds: timer.tick);
        notifyListeners();
      }
    });
  }

  // Formatting for UI
  String get formattedDuration {
    if (_currentSession == null) return "00:00";
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(_currentSession!.duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(_currentSession!.duration.inSeconds.remainder(60));
    if (_currentSession!.duration.inHours > 0) {
      return "${twoDigits(_currentSession!.duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
    }
    return "$twoDigitMinutes:$twoDigitSeconds";
  }

  String getDisplayStatus() {
    switch (_status) {
      case CallStatus.dialing: return "Contacting...";
      case CallStatus.ringing: return "Ringing...";
      case CallStatus.connecting: return "Connecting...";
      case CallStatus.active: return formattedDuration;
      case CallStatus.muted: return "Muted";
      case CallStatus.ended: return "Call Ended";
      case CallStatus.unavailable: return "Unavailable";
      default: return "";
    }
  }

  @override
  void dispose() {
    _durationTimer?.cancel();
    _simulatedNetworkTimer?.cancel();
    super.dispose();
  }
}
