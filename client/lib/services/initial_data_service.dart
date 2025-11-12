import 'dart:convert';
import 'package:client/models/initial_data.dart';
import 'package:http/http.dart' as http;


class InitialService {
  Future<InitialData> fetchInit() async{
    const url = "http://10.0.2.2:8000/";
    // const path = "/";

    final response = await http.get(Uri.parse(url));

    if(response.statusCode == 200){
      Map<String, dynamic> data = json.decode(response.body);
      // return data.map((initialData)=>InitialData.fromJson(initialData)).toList();
      return InitialData.fromJson(data);
    }
    else{
      throw Exception('초기화 정보 불러오기 실패 : ${response.statusCode}');
    }
  }
}

