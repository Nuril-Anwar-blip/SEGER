class BoneTransform {
  final String boneName;
  final double translationX;
  final double translationY;
  final double rotation; // in radians

  BoneTransform({
    required this.boneName,
    this.translationX = 0.0,
    this.translationY = 0.0,
    this.rotation = 0.0,
  });
}

class RivePoseState {
  final List<BoneTransform> transforms;
  final double matchScore;
  final double attentionScore;
  final bool isPoseDetected;

  RivePoseState({
    required this.transforms,
    this.matchScore = 0.0,
    this.attentionScore = 1.0,
    this.isPoseDetected = false,
  });
}
