import 'dart:io' show Platform;

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import 'package:permission_handler/permission_handler.dart';

/// Exercise screen combining real-time camera + ML Kit pose/face detection
/// (backend/ML logic) with the polished SEGER UI overlay (frontend).
class ExerciseScreen extends ConsumerStatefulWidget {
  const ExerciseScreen({super.key});

  @override
  ConsumerState<ExerciseScreen> createState() => _ExerciseScreenState();
}

class _ExerciseScreenState extends ConsumerState<ExerciseScreen> {
  // Kamera
  CameraController? _cameraController;
  CameraDescription? _frontCamera;
  bool _isInitialized = false;

  // ML Kit detectors
  late final PoseDetector _poseDetector;
  late final FaceDetector _faceDetector;

  bool _isProcessing = false;
  int _frameCount = 0;

  // State latihan
  bool _isPaused = false;
  final String _currentExercise = 'Angkat Tangan';
  double _matchScore = 0.0;
  double _attentionScore = 1.0; // 0.0–1.0 dari probabilitas mata terbuka

  // ── Landmark hasil
  List<Pose> _poses = [];

  @override
  void initState() {
    super.initState();
    _initMLKit();
    _initCamera();
  }

  void _initMLKit() {
    _poseDetector = PoseDetector(
      options: PoseDetectorOptions(
        mode: PoseDetectionMode.stream,
      ),
    );

    _faceDetector = FaceDetector(
      options: FaceDetectorOptions(
        enableClassification: true,
        performanceMode: FaceDetectorMode.fast, // prioritas kecepatan
      ),
    );
  }

  // Inisialisasi Kamera
  Future<void> _initCamera() async {
    final status = await Permission.camera.request();
    if (status != PermissionStatus.granted) {
      debugPrint('Permission kamera ditolak');
      return;
    }

    final cameras = await availableCameras();
    if (cameras.isEmpty) return;

    _frontCamera = cameras.firstWhere(
      (c) => c.lensDirection == CameraLensDirection.front,
      orElse: () => cameras.first, // fallback ke kamera pertama jika tidak ada front
    );

    _cameraController = CameraController(
      _frontCamera!,
      ResolutionPreset.medium,
      enableAudio: false,
      imageFormatGroup: Platform.isAndroid
          ? ImageFormatGroup.nv21
          : ImageFormatGroup.bgra8888,
    );

    try {
      await _cameraController!.initialize();
      if (!mounted) return;
      setState(() => _isInitialized = true);
      _startImageStream(); // ← koneksi kamera ke ML Kit
    } catch (e) {
      debugPrint('Camera init error: $e');
    }
  }

  void _startImageStream() {
    _cameraController!.startImageStream((CameraImage image) {
      // Lewati jika sedang proses atau di-pause
      if (_isProcessing || _isPaused) return;

      _frameCount++;
      if (_frameCount.isEven) {
        _processPose(image);
      } else {
        _processFace(image);
      }
    });
  }

  // Proses pose
  Future<void> _processPose(CameraImage image) async {
    _isProcessing = true;
    try {
      final inputImage = _buildInputImage(image);
      final poses = await _poseDetector.processImage(inputImage);

      if (mounted) {
        setState(() {
          _poses = poses;
          _matchScore = _calculatePoseScore(poses);
        });
      }
    } catch (e) {
      debugPrint('Pose error: $e');
    } finally {
      _isProcessing = false;
    }
  }

  // Proses wajah / perhatian
  Future<void> _processFace(CameraImage image) async {
    _isProcessing = true;
    try {
      final inputImage = _buildInputImage(image);
      final faces = await _faceDetector.processImage(inputImage);

      if (mounted) {
        setState(() {
          _attentionScore = _calculateAttentionScore(faces);
        });
      }
    } catch (e) {
      debugPrint('Face error: $e');
    } finally {
      _isProcessing = false;
    }
  }

  // Konversi CameraImage
  InputImage _buildInputImage(CameraImage image) {
    // Rotasi sensor → enum ML Kit
    final rotation = InputImageRotationValue.fromRawValue(
          _frontCamera!.sensorOrientation,
        ) ??
        InputImageRotation.rotation270deg;

    final format = Platform.isAndroid
        ? InputImageFormat.nv21
        : InputImageFormat.bgra8888;

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

  // Hitung skor gerakan
  double _calculatePoseScore(List<Pose> poses) {
    if (poses.isEmpty) return 0.0;

    final pose = poses.first;

    final leftShoulder = pose.landmarks[PoseLandmarkType.leftShoulder];
    final rightShoulder = pose.landmarks[PoseLandmarkType.rightShoulder];
    final leftWrist = pose.landmarks[PoseLandmarkType.leftWrist];
    final rightWrist = pose.landmarks[PoseLandmarkType.rightWrist];

    if (leftShoulder == null ||
        rightShoulder == null ||
        leftWrist == null ||
        rightWrist == null) {
      return 0.0;
    }

    int score = 0;
    if (leftWrist.y < leftShoulder.y) score += 50;
    if (rightWrist.y < rightShoulder.y) score += 50;

    return score.toDouble();
  }

  // Hitung skor perhatian dari probabilitas mata terbuka
  double _calculateAttentionScore(List<Face> faces) {
    if (faces.isEmpty) return 0.0;

    final face = faces.first;
    final leftEye = face.leftEyeOpenProbability ?? 1.0;
    final rightEye = face.rightEyeOpenProbability ?? 1.0;

    return (leftEye + rightEye) / 2.0;
  }

  void _togglePause() => setState(() => _isPaused = !_isPaused);

  void _finishSession() {
    Navigator.pushNamed(context, '/reward');
  }

  @override
  void dispose() {
    _cameraController?.stopImageStream();
    _cameraController?.dispose();
    _poseDetector.close(); // bukan dispose(), tapi close()
    _faceDetector.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAF8),
      appBar: AppBar(
        title: const Text('Latihan SEGER'),
        backgroundColor: Colors.black87,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                // Preview kamera
                if (_isInitialized && _cameraController != null)
                  CameraPreview(_cameraController!)
                else
                  const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 12),
                        Text('Mempersiapkan kamera dan detektor...'),
                      ],
                    ),
                  ),

                // Overlay info gerakan + skor
                Positioned(
                  top: 20,
                  left: 20,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Gerakan: $_currentExercise',
                          style: const TextStyle(
                              color: Colors.white, fontSize: 18),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Skor: ${_matchScore.toStringAsFixed(0)}%',
                          style: TextStyle(
                            color: _matchScore > 70
                                ? Colors.greenAccent
                                : Colors.orangeAccent,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Fokus: ${(_attentionScore * 100).toStringAsFixed(0)}%',
                          style: TextStyle(
                            color: _attentionScore > 0.5
                                ? Colors.lightBlueAccent
                                : Colors.redAccent,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Indikator pause
                if (_isPaused)
                  const Center(
                    child: Icon(Icons.pause_circle_filled,
                        color: Colors.white54, size: 80),
                  ),
              ],
            ),
          ),

          // Tombol kontrol
          Container(
            padding: const EdgeInsets.all(20),
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: _togglePause,
                  icon: Icon(_isPaused ? Icons.play_arrow : Icons.pause),
                  label: Text(_isPaused ? 'Lanjut' : 'Pause'),
                ),
                ElevatedButton.icon(
                  onPressed: _finishSession,
                  icon: const Icon(Icons.stop),
                  label: const Text('Selesai'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00685D),
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
