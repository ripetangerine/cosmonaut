import 'dart:typed_data';
import 'package:flutter/material.dart';
// import 'package:client/models/whitenoise_model.dart';
import "package:client/services/whitenoise_service.dart";
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class WhiteNoiseViewModel extends ChangeNotifier {
  final WhiteNoiseService _service = WhiteNoiseService();
  final AudioPlayer _player = AudioPlayer();

  List<String>? _audioListData;
  List<String>? get audioListData => _audioListData;
  
  Uint8List? _audioData;
  Uint8List? get audioData => _audioData;

  bool _loading = false;
  bool get loading => _loading;

  String? _error;
  String? get error => _error;

  Future<void> loadCurrentAudio() async {
    _loading = true;
    notifyListeners();
    try {
      _audioListData = await _service.fetchAudioList();
      _error = null;
    } catch (e) {
      _error = e.toString();
    }
    _loading = false;
    notifyListeners();
  }

// 플레이하는 오디오 받아오는 함수
  Future<void> fetchPlayAudio({
    required String title
  }) async {
    _loading = true;
    notifyListeners();
    try {
      _audioData = await _service.fetchPlayAudio(title:title);
      _error = null;
    } catch (e) {
      _error = e.toString();
    }
    _loading = false;
    notifyListeners();
  }

  Future<void> playAudio({
    required String title
  }) async {
    final baseUrl = dotenv.env['BASE_URL'];

    if (_audioData == null) return;
    await _player.stop();
    await _player.play(UrlSource("$baseUrl/whitenoise/play?noise_title=$title"));
  }
}
