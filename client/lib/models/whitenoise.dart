class WhiteNoiseModel {
  final String audioName;
  final String audioUrl;
  final String utcTime;
  final String solDate;

  WhiteNoiseModel({
    required this.audioName,
    required this.audioUrl,
    required this.utcTime,
    required this.solDate,
  });

  factory WhiteNoiseModel.fromJson(Map<String, dynamic> json) {
    return WhiteNoiseModel(
      audioName: json['audioName'],
      audioUrl: json['audioUrl'],
      utcTime: json['utcTime'],
      solDate: json['solDate'],
    );
  }
}
