import 'dart:math';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import '../../models/pose_frame.dart';

class PoseMathUtils {
  /// Calculate angle between two landmarks in radians
  static double angleBetween(NormalizedLandmark from, NormalizedLandmark to) {
    return atan2(to.y - from.y, to.x - from.x);
  }

  /// Calculate joint angle (e.g., elbow angle) between 3 points in degrees
  static double calculateJointAngle(NormalizedLandmark p1, NormalizedLandmark p2, NormalizedLandmark p3) {
    double angle1 = atan2(p1.y - p2.y, p1.x - p2.x);
    double angle2 = atan2(p3.y - p2.y, p3.x - p2.x);
    double angle = (angle1 - angle2).abs() * 180 / pi;
    if (angle > 180) angle = 360 - angle;
    return angle;
  }

  /// Normalize a PoseLandmark from pixel coordinates to 0.0-1.0
  static NormalizedLandmark normalizeLandmark(PoseLandmark lm, double frameWidth, double frameHeight) {
    return NormalizedLandmark(
      lm.x / frameWidth,
      lm.y / frameHeight,
    );
  }

  /// Linear interpolation for smoothing
  static double lerp(double a, double b, double t) {
    return a + (b - a) * t;
  }
}
