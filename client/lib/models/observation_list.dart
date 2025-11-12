import 'observation.dart';

class ObservationList {
  final List<Observation> observations;

  ObservationList({required this.observations});

  factory ObservationList.fromJson(List<dynamic> jsonList) {
    return ObservationList(
      observations: jsonList.map((e) => Observation.fromJson(e)).toList(),
    );
  }
}
