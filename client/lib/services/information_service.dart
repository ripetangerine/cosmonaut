import 'dart:convert';
import 'package:http/http.dart' as http;
// import 'package:client/models/information.dart';


class InformationService {
  final String baseUrl = "http://10.0.2.2:8000";

  Future<> fetchCalender({
    required String year,
    required String month,
  }) async{
    final response = await http.
  }
}