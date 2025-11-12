class ObservationPosition {
  final String id;
  final String name;
  final double mag;
  final double alt;
  final double az;

  ObservationPosition({
    required this.id,
    required this.name,
    required this.mag,
    required this.alt,
    required this.az,
  });
  
  factory ObservationPosition.fromJson(Map<String, dynamic> json) {
    return ObservationPosition(
      id: json['id'],
      name: json['name'],
      mag: json['mag'].toDouble(),
      alt: json['alt'].toDouble(),
      az : json['az'].toDouble(),
    );
  }
}
