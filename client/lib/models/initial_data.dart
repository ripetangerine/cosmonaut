import 'package:client/models/calender.dart';
import 'package:client/models/whitenoise.dart';
import 'package:client/models/observation.dart';
import 'package:client/models/star_position.dart';
import 'package:client/models/mars_date.dart';


class InitialData{
  final Calender? calender;
  final Observation? observation; 
  final Whitenoise? whitenoise;
  final StarPosition? starPosition;
  final MarsDate? marsDate;

  InitialData({
    required this.calender,
    required this.observation,
    required this.whitenoise,
    required this.starPosition,
    required this.marsDate,
  });

  factory InitialData.fromJson(Map<dynamic, dynamic> json){
  return InitialData(
    calender : json['calender'],
    observation : json['observation'],
    whitenoise : json['whitenoise'],
    starPosition : json['starPosition'],
    marsDate : json['marsDate'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'calender' : calender,
      'observation' : observation,
      'whitenoise' : whitenoise,
      'starPosition' : starPosition,
      'marsDate' : marsDate,
    };
  }
  
}