import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:client/models/whitenoise.dart';

class WhiteNoiseService {
  final baseUrl = dotenv.env['BASE_URL'];

  Future<List<String>> fetchAudioList () async {
    final response = await http.get(Uri.parse("$baseUrl/whitenoise/"));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data;
    } else {
      throw Exception("화이트노이즈 데이터를 불러오지 못했습니다.");
    }
  }

  Future<WhiteNoiseModel> fetchNextAudio({
    required String title
  }) async {
    final response = await http.get(Uri.parse("$baseUrl/whitenoise/next").replace(
      queryParameters: {
        "noise_title": title
      }
    ));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return WhiteNoiseModel.fromJson(data);
    } else {
      throw Exception("다음 오디오 데이터를 불러오지 못했습니다.");
    }
  }
}
