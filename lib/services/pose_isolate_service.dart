import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import '../models/pose_frame.dart';
import '../core/utils/pose_math_utils.dart';

class PoseIsolateService {
  late final PoseDetector _poseDetector;
  late final FaceDetector _faceDetector;

  final _poseController = StreamController<PoseFrame>.broadcast();
  Stream<PoseFrame> get poseStream => _poseController.stream;

  bool _isProcessing = false;
  int _frameCount = 0;

  double _lastAttentionScore = 1.0;

  PoseIsolateService() {
    _poseDetector = PoseDetector(
      options: PoseDetectorOptions(
        mode: PoseDetectionMode.stream,
      ),
    );

    _faceDetector = FaceDetector(
      options: FaceDetectorOptions(
        enableClassification: true,
        performanceMode: FaceDetectorMode.fast,
      ),
    );
  }

  Future<void> processFrame(CameraImage image, CameraDescription camera) async {
    if (_isProcessing) return;
    _isProcessing = true;

    try {
      final inputImage = _buildInputImage(image, camera);
      _frameCount++;

      List<Pose> poses = [];
      List<Face> faces = [];

      // Alternate processing to save resources
      if (_frameCount.isEven) {
        // Native background thread inference
        poses = await _poseDetector.processImage(inputImage);
      } else {
        faces = await _faceDetector.processImage(inputImage);
        if (faces.isNotEmpty) {
          final face = faces.first;
          final leftEye = face.leftEyeOpenProbability ?? 1.0;
          final rightEye = face.rightEyeOpenProbability ?? 1.0;
          _lastAttentionScore = (leftEye + rightEye) / 2.0;
        }
      }

      // Perform mapping on main thread because ML Kit FFI objects cannot be sent to isolates.
      // Math is very light and won't drop frames.
      if (poses.isNotEmpty) {
        final poseFrame = _convertPoseToFrame(poses, image.width.toDouble(), image.height.toDouble());
        _poseController.add(poseFrame);
      }
    } catch (e) {
      debugPrint('Pose processing error: $e');
    } finally {
      _isProcessing = false;
    }
  }

  PoseFrame _convertPoseToFrame(List<Pose> poses, double width, double height) {
    final pose = poses.first;
    final Map<String, NormalizedLandmark> normalized = {};

    pose.landmarks.forEach((type, landmark) {
      normalized[type.name] = PoseMathUtils.normalizeLandmark(landmark, width, height);
    });

    double matchScore = 0.0;
    final leftShoulder = pose.landmarks[PoseLandmarkType.leftShoulder];
    final rightShoulder = pose.landmarks[PoseLandmarkType.rightShoulder];
    final leftWrist = pose.landmarks[PoseLandmarkType.leftWrist];
    final rightWrist = pose.landmarks[PoseLandmarkType.rightWrist];

    if (leftShoulder != null && rightShoulder != null && leftWrist != null && rightWrist != null) {
      if (leftWrist.y < leftShoulder.y) matchScore += 50;
      if (rightWrist.y < rightShoulder.y) matchScore += 50;
    }

    return PoseFrame(
      landmarks: normalized,
      matchScore: matchScore,
      attentionScore: _lastAttentionScore,
    );
  }

  InputImage _buildInputImage(CameraImage image, CameraDescription camera) {
    final rotation = InputImageRotationValue.fromRawValue(camera.sensorOrientation) ??
        InputImageRotation.rotation270deg;

    final format = Platform.isAndroid ? InputImageFormat.nv21 : InputImageFormat.bgra8888;

    return InputImage.fromBytes(
      bytes: image.planes[0].bytes,
      metadata: InputImageMetadata(
        size: Size(image.width.toDouble(), image.height.toDouble()),
        rotation: rotation,
        format: format,
        bytesPerRow: image.planes[0].bytesPerRow,
      ),
    );
  }

  Future<void> dispose() async {
    await _poseController.close();
    await _poseDetector.close();
    await _faceDetector.close();
  }
}
