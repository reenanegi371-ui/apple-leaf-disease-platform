class DetectionResult {
  final String id;
  final String diseaseName;
  final double confidence;
  final String imagePath;
  final DateTime timestamp;
  final Map<String, double> allProbabilities;

  DetectionResult({
    required this.id,
    required this.diseaseName,
    required this.confidence,
    required this.imagePath,
    required this.timestamp,
    required this.allProbabilities,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'disease_name': diseaseName,
      'confidence': confidence,
      'image_path': imagePath,
      'timestamp': timestamp.toIso8601String(),
      'all_probabilities': allProbabilities,
    };
  }

  factory DetectionResult.fromJson(Map<String, dynamic> json) {
    return DetectionResult(
      id: json['id'],
      diseaseName: json['disease_name'],
      confidence: json['confidence'].toDouble(),
      imagePath: json['image_path'],
      timestamp: DateTime.parse(json['timestamp']),
      allProbabilities: Map<String, double>.from(
        (json['all_probabilities'] as Map).map(
          (key, value) => MapEntry(key, (value as num).toDouble()),
        ),
      ),
    );
  }
}