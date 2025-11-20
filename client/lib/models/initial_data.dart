import 'package:client/models/whitenoise.dart';
import 'package:client/models/observation.dart';
import 'package:client/models/observation_position.dart';


class InitialData{
  final Observation? observation; 
  final Whitenoise? whitenoise;
  final StarPosition? starPosition;
  final MarsDate? marsDate;

  InitialData({
    required this.observation,
    required this.whitenoise,
    required this.starPosition,
    required this.marsDate,
  });

  factory InitialData.fromJson(Map<dynamic, dynamic> json){
  return InitialData(
    observation : json['observation'],
    whitenoise : json['whitenoise'],
    starPosition : json['starPosition'],
    marsDate : json['marsDate'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'observation' : observation,
      'whitenoise' : whitenoise,
      'starPosition' : starPosition,
      'marsDate' : marsDate,
    };
  }
  
}