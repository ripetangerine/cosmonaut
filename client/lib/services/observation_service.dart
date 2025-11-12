import "dart:convert";
import 'package:client/models/observation_position.dart';
import 'package:http/http.dart' as http;
import 'package:client/models/observation.dart';

class ObservationService {
  final String baseUrl = 'http://10.0.2.2:8000/';

  Future<List<Observation>> fetchObservation({
    required String type,
    required String startDate,
    required String endDate,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/'),
      headers: {"Content-Text" : "application/json"},
      body: {
        'type' : type,
        'startDate' : startDate,
        'endDate' : endDate,
      }
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((e) => Observation.fromJson(e)).toList();
    } else {
      throw Exception('관찰 일지 정보를 불러오지 못했습니다.');
    }
  }

  Future<List<Observation>> fetchObservationAll({
    required String type
  }) async{
    final response = await http.post(Uri.parse('$baseUrl/all'), 
      headers: {"Content-Type" : "application/json"},
      body :{"type" : type},
    );

    if(response.statusCode == 200){
      final List<dynamic> data = json.decode(response.body);
      return data.map((e) => Observation.fromJson(e)).toList();
    } else{
      throw Exception('관찰 일지 정보를 불러오지 못했습니다.');
    }
  }

  Future<ObservationPosition> fetchObservationPosition({
    required double lat,
    required double lon,
    required String datetime 
  }) async{
    final response = await http.post(
      Uri.parse('$baseUrl/position'),
      headers: {"Content-Type" : "applicaiton/json"},
      body: {"lat" : lat, "lon" : lon, "datetime" : datetime}
    );

    if(response.statusCode == 200){
      final Map<String, dynamic> data = json.decode(response.body);
      return ObservationPosition.fromJson(data);
    }
    else{
      throw Exception("별 위치 정보를 불러오지 못했습니다;");
    }
  }
}

