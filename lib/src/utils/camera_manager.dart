import 'package:flutter_webrtc/flutter_webrtc.dart';

class CameraManager {
  final Map<String, MediaDeviceInfo> _cameras = {};
  String _selectedCamera = 'back';

  CameraManager() {
    _init();
  }

  Future<void> _init() async {
    List<MediaDeviceInfo> devices = await navigator.mediaDevices.enumerateDevices();
    for (var device in devices.where((d) => d.kind == 'videoinput')) {
      final label = device.label.toLowerCase();
      if (label.contains('front')) {
        _cameras['front'] = device;
      } else if (label.contains('back')) {
        _cameras['back'] = device;
      } else {
        _cameras['uvc'] = device;
      }
    }
  }

  void selectCamera(String camera) {
    _selectedCamera = camera;
  }

  Future<MediaStreamTrack> getUVCVideoTrack() async {
    if (_selectedCamera != 'uvc') throw Exception("UVC camera is not selected");
    final device = _cameras[_selectedCamera];
    if (device == null) throw Exception("No UVC camera found");
    final constraints = {
      'audio': false,
      'video': {
        'deviceId': device.deviceId,
      },
    };
    final stream = await navigator.mediaDevices.getUserMedia(constraints);
    return stream.getVideoTracks().first;
  }
}
