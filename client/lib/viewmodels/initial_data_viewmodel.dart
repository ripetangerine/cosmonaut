

import 'package:client/models/initial_data.dart';
import 'package:client/services/initial_data_service.dart';
import 'package:flutter/material.dart';

class InitialDataViewmodel extends ChangeNotifier {
  final InitialService _service = InitialService();
  InitialData? _initialData;
  bool _loading = false;

  InitialData? get initialData => _initialData;
  bool get loading => _loading;

  Future<void> fetchInitial() async {
    _loading = true;
    notifyListeners();

    _initialData = (await _service.fetchInit()) as InitialData?;

    _loading = false;
    notifyListeners();
  }
}