import 'package:flutter/material.dart';
import 'package:client/models/observation.dart';
import 'package:client/models/observation_position.dart';
import 'package:client/services/observation_service.dart';

class ObservationViewModel extends ChangeNotifier{
  final ObservationService _service = ObservationService();

  late Observation _observation; // late 키워드 추가
  late List<Observation> _observations = [];
  late List<ObservationPosition> _observationPosition = [];
  String type = "";
  bool _loading = true;
  String? _errorMessage;

  // getter
  Observation get observation => _observation;
  List<Observation> get observations => _observations;
  List<ObservationPosition> get observationPosition => _observationPosition;
  bool get loading => _loading;
  String? get errorMessage => _errorMessage;

  // 서비스 호출
  Future<Observation?> fetchOne({
    required String type,
    required String startDate,
    required String endDate
  }) async {
    _loading = true;
    notifyListeners();
    try{
      _observation = await _service.fetchObservation(
        type : type,
        startDate: startDate,
        endDate : endDate,
      );
      return _observation;
    } catch (e){
      _errorMessage = e.toString();
      return null;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
  Future<List<Observation>> fetchAll({
    required String type,
  }) async{
    _loading = true;
    notifyListeners();
    try{
      final answer = await _service.fetchObservationAll(type: type);
      _observations = answer;
      _errorMessage = null;
      return answer;
    }
    catch(e){
      _errorMessage = e.toString();
      return [];
    }
    finally{
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> fetchPosition({
    required double lat,
    required double lon,
    required String datetime 
  }) async{
    _loading = true;
    notifyListeners();
    try {
      _observationPosition = [await _service.fetchObservationPosition(lat: lat, lon: lon, datetime: datetime)];
      _errorMessage = null;
    } catch(e){
      _errorMessage = e.toString();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
}