class PoseFrame {
  final Map<String, NormalizedLandmark> landmarks;
  final double matchScore;
  final double attentionScore;

  PoseFrame({
    required this.landmarks,
    this.matchScore = 0.0,
    this.attentionScore = 1.0,
  });
}

class NormalizedLandmark {
  final double x;
  final double y;

  NormalizedLandmark(this.x, this.y);
}
