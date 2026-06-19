import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/camera_provider.dart';
import '../../providers/pose_provider.dart';
import '../../widget/exercise/rive_exercise_widget.dart';

/// Exercise screen combining real-time camera + ML Kit pose/face detection
/// (backend/ML logic) with the polished SEGER UI overlay (frontend).
class ExerciseScreen extends ConsumerStatefulWidget {
  const ExerciseScreen({super.key});

  @override
  ConsumerState<ExerciseScreen> createState() => _ExerciseScreenState();
}

class _ExerciseScreenState extends ConsumerState<ExerciseScreen> {
  /// Berapa kali berturut-turut skor == 100 sebelum dianggap sukses.
  /// Ini mencegah false positive dari satu frame kebetulan.
  static const int _requiredSuccessFrames = 15; // ~0.5 detik pada 30fps
  int _successFrameCount = 0;
  bool _hasNavigatedToSuccess = false;
  bool _isPausedLocal = false;

<<<<<<< HEAD
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
=======
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (mounted) {
        ref.read(cameraControllerProvider.notifier).initCamera();
>>>>>>> origin/fitur-rive-iqbal
      }
    });
  }

<<<<<<< HEAD
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
=======
  @override
  void dispose() {
    _stopStreaming();
>>>>>>> origin/fitur-rive-iqbal
    super.dispose();
  }

  void _startStreaming() {
    final cameraState = ref.read(cameraControllerProvider);
    final isPaused = ref.read(isPausedProvider);
    
    if (cameraState.hasValue && cameraState.value != null && !isPaused) {
      final controller = cameraState.value!;
      if (!controller.value.isStreamingImages) {
        final poseService = ref.read(poseServiceProvider);
        final frontCamera = ref.read(cameraControllerProvider.notifier).frontCamera;
        
        if (frontCamera != null) {
          controller.startImageStream((image) {
            if (!mounted || _isPausedLocal) return; 
            poseService.processFrame(image, frontCamera);
          });
        }
      }
    }
  }

  void _stopStreaming() {
    final cameraState = ref.read(cameraControllerProvider);
    if (cameraState.hasValue && cameraState.value != null) {
      final controller = cameraState.value!;
      if (controller.value.isStreamingImages) {
        controller.stopImageStream();
      }
    }
  }

  /// Cek apakah latihan sudah berhasil (skor 100% selama N frame berturut-turut)
  void _checkExerciseSuccess(double matchScore) {
    if (_hasNavigatedToSuccess) return;

    if (matchScore >= 100.0) {
      _successFrameCount++;
      if (_successFrameCount >= _requiredSuccessFrames) {
        _hasNavigatedToSuccess = true;
        _stopStreaming();

        // Navigasi ke layar sukses setelah frame selesai build
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            Navigator.pushReplacementNamed(context, '/exercise/success');
          }
        });
      }
    } else {
      // Reset counter jika skor turun
      _successFrameCount = 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final cameraState = ref.watch(cameraControllerProvider);
    final isPaused = ref.watch(isPausedProvider);
    _isPausedLocal = isPaused; // Simpan ke lokal agar aman diakses oleh callback kamera

    final poseState = ref.watch(poseStreamProvider);
    
    final matchScore = poseState.valueOrNull?.matchScore ?? 0.0;
    final attentionScore = poseState.valueOrNull?.attentionScore ?? 1.0;

    // Start/stop streaming berdasarkan state
    if (cameraState.hasValue && cameraState.value != null) {
      if (!isPaused) {
        _startStreaming();
      } else {
        _stopStreaming();
      }
    }

    // Cek sukses setiap ada data pose baru
    _checkExerciseSuccess(matchScore);

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
                // Layer 1: Rive Animation Background
                const RiveExerciseWidget(),

                // Layer 2: Camera preview (mini, corner)
                if (cameraState.isLoading)
                  const Center(child: CircularProgressIndicator())
                else if (cameraState.hasValue && cameraState.value != null)
                  Positioned(
                    right: 16,
                    top: 16,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: SizedBox(
                        width: 100,
                        height: 140,
                        child: CameraPreview(cameraState.value!),
                      ),
                    ),
                  ),

                // Layer 3: Overlay Info
                Positioned(
                  top: 20,
                  left: 20,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.8),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Gerakan: Angkat Tangan',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Skor: ${matchScore.toStringAsFixed(0)}%',
                          style: TextStyle(
                            color: matchScore > 70 ? Colors.greenAccent : Colors.orangeAccent,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Fokus: ${(attentionScore * 100).toStringAsFixed(0)}%',
                          style: TextStyle(
                            color: attentionScore > 0.5 ? Colors.lightBlueAccent : Colors.redAccent,
                            fontSize: 16,
                          ),
                        ),
                        // Progress bar ke sukses
                        if (_successFrameCount > 0) ...[
                          const SizedBox(height: 8),
                          SizedBox(
                            width: 150,
                            child: LinearProgressIndicator(
                              value: _successFrameCount / _requiredSuccessFrames,
                              backgroundColor: Colors.white24,
                              valueColor: const AlwaysStoppedAnimation<Color>(Colors.greenAccent),
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Tahan posisi...',
                            style: TextStyle(color: Colors.greenAccent, fontSize: 12),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),

                // Pause indicator
                if (isPaused)
                  const Center(
                    child: Icon(Icons.pause_circle_filled, color: Colors.white54, size: 80),
                  ),
              ],
            ),
          ),

          // Layer 4: Controls
          Container(
            padding: const EdgeInsets.all(20),
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
<<<<<<< HEAD
                  onPressed: _togglePause,
                  icon: Icon(_isPaused ? Icons.play_arrow : Icons.pause),
                  label: Text(_isPaused ? 'Lanjut' : 'Pause'),
=======
                  onPressed: () {
                    ref.read(isPausedProvider.notifier).state = !isPaused;
                  },
                  icon: Icon(isPaused ? Icons.play_arrow : Icons.pause),
                  label: Text(isPaused ? 'Lanjut' : 'Pause'),
>>>>>>> origin/fitur-rive-iqbal
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
