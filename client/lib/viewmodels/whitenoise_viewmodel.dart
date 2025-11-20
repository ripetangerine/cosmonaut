
import 'package:flutter/material.dart';
// import 'package:client/models/whitenoise_model.dart';
import "package:client/services/whitenoise_service.dart";
import 'package:audioplayers/audioplayers.dart';

class WhiteNoiseViewModel extends ChangeNotifier {
  final WhiteNoiseService _service = WhiteNoiseService();
  final AudioPlayer _player = AudioPlayer();

  List<String>? _audioListData;
  List<String>? get audioListData => _audioListData;
  ``
  Map<String, dynamic>? _audioData;
  Map<String, dynamic>? get audioData => _audioData;

  bool _loading = false;
  bool get loading => _loading;

  String? _error;
  String? get error => _error;

  Future<void> loadCurrentAudio() async {
    _loading = true;
    notifyListeners();

    try {
      _audioData = await _service.fetchAudio();
      _error = null;
    } catch (e) {
      _error = e.toString();
    }

    _loading = false;
    notifyListeners();
  }


  Future<void> fetchNextAudio({
    required String title
  }) async {
    _loading = true;
    notifyListeners();

    try {
      _audioData = await _service.fetchNextAudio(title:title);
      _error = null;
    } catch (e) {
      _error = e.toString();
    }

    _loading = false;
    notifyListeners();
  }


  Future<void> playAudio() async {
    if (_audioData == null) return;

    await _player.stop();
    await _player.play(UrlSource(_audioData!.audioUrl));
  }
}
