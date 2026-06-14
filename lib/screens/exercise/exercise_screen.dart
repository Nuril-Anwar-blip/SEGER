import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/camera_provider.dart';
import '../../providers/pose_provider.dart';
import '../../widget/exercise/rive_exercise_widget.dart';

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

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (mounted) {
        ref.read(cameraControllerProvider.notifier).initCamera();
      }
    });
  }

  @override
  void dispose() {
    _stopStreaming();
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
                  onPressed: () {
                    ref.read(isPausedProvider.notifier).state = !isPaused;
                  },
                  icon: Icon(isPaused ? Icons.play_arrow : Icons.pause),
                  label: Text(isPaused ? 'Lanjut' : 'Pause'),
                ),
                ElevatedButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.stop),
                  label: const Text('Selesai'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}