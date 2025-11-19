import 'dart:collection';
import 'dart:convert';
import 'package:http/http.dart' as http;
// import 'package:client/models/information.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';


class InformationService {
  final baseUrl = dotenv.env['BASE_URL'];

  Future<bool> fetchCalenderCheck() async{
    final url = Uri.parse("$baseUrl/calender/check");
    final response = await http.get(url);
    if(response.statusCode == 200){
      final Map<String, dynamic> data = json.decode(response.body);
      return data['status'] as bool;
      
      // TODO : useMemo 와 같은 기능을 추후 사용해서 해당 자료를 별도 디바이스에 저장해서 기능 향상
    } else {
      throw Exception('calender/check 정보를 불러오지 못했습나');
    }
  }

  Future<Map<String, dynamic>> fetchCalender({
    required String year,
    required String month,  
  }) async {
    final url = Uri.parse('$baseUrl/calender').replace(
      queryParameters: {
        'year' : year,
        'month' : month
      }
    );
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return data;
    } else {
      throw Exception('관찰 일지 정보를 불러오지 못했습니다.');
    }
  }

  Future<String> fetchMars() async {
    final url = Uri.parse('$baseUrl/mars');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final String data = json.decode(response.body);
      return data;
    } else {
      throw Exception('천체를 불러오지 못했습니다.');
    }
  }

  Future<String> fetchMarsDate() async {
    final url = Uri.parse('$baseUrl/mars/date');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final String data = json.decode(response.body);
      return data;
    } else {
      throw Exception('천체를 불러오지 못했습니다.');
    }
  }

  Future<String> fetchEarth() async {
    final url = Uri.parse('$baseUrl/earth');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final String data = json.decode(response.body);
      return data;
    } else {
      throw Exception('천체를 불러오지 못했습니다.');
    }
  }

  Future<String> fetchSolar() async {
    final url = Uri.parse('$baseUrl/solar');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final String data = json.decode(response.body);
      return data;
    } else {
      throw Exception('천체를 불러오지 못했습니다.');
    }
  }
}