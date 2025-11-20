import 'package:flutter/foundation.dart';
import 'package:client/services/information_service.dart';

class InformationViewModel with ChangeNotifier {
  final InformationService _service = InformationService();

  //
  bool isLoading = false;
  String? errorMessage;

  bool? calenderStatus;
  Map<String, dynamic>? calenderData;

  String? marsData;
  String? marsDateData;
  String? earthData;
  String? solarData;

  // 
  void _startLoading() {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
  }

  void _endLoading() {
    isLoading = false;
    notifyListeners();
  }

  void _setError(String e) {
    errorMessage = e;
    notifyListeners();
  }

  Future<void> checkCalender() async {
    _startLoading();
    try {
      final result = await _service.fetchCalenderCheck();
      calenderStatus = result as bool?;
    } catch (e) {
      _setError(e.toString());
    }
    _endLoading();
  }

  Future<void> loadCalender(String year, String month) async {
    _startLoading();
    try {
      final result = await _service.fetchCalender(
        year: year,
        month: month,
      );
      calenderData = result;
    } catch (e) {
      _setError(e.toString());
    }
    _endLoading();
  }

  Future<void> loadMars() async {
    _startLoading();
    try {
      marsData = await _service.fetchMars();
    } catch (e) {
      _setError(e.toString());
    }
    _endLoading();
  }

  Future<String?> loadMarsDate() async {
    _startLoading();
    try {
      marsDateData = await _service.fetchMarsDate();
      // return marsDateData;
    } catch (e) {
      _setError(e.toString());
    }
     _endLoading();
    return marsDateData;
  }

  Future<void> loadEarth() async {
    _startLoading();
    try {
      earthData = await _service.fetchEarth();
    } catch (e) {
      _setError(e.toString());
    }
    _endLoading();
  }

  Future<void> loadSolar() async {
    _startLoading();
    try {
      solarData = await _service.fetchSolar();
    } catch (e) {
      _setError(e.toString());
    }
    _endLoading();
  }
}
