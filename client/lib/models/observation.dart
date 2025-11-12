
class Observation {
  final String id;
  final String objectType;
  final String timeStamp;
  final String eventTime;
  final String eventTitle;
  final String content;
  

  Observation({
    required this.id,
    required this.objectType,
    required this.timeStamp,
    required this.eventTime,
    required this.eventTitle,
    required this.content
  });

  factory Observation.fromJson(Map<String, dynamic> json) {
    return Observation(
      id: json['id'],
      objectType: json['objectType'],
      timeStamp: json['timeStamp'],
      eventTime: json['eventTime'],
      eventTitle: json['eventTitle'],
      content: json['content']
    );
  }
}
