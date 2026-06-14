import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';

final cameraControllerProvider = StateNotifierProvider<CameraNotifier, AsyncValue<CameraController?>>((ref) {
  return CameraNotifier();
});

class CameraNotifier extends StateNotifier<AsyncValue<CameraController?>> {
  CameraNotifier() : super(const AsyncValue.loading());
  
  CameraDescription? _frontCamera;
  
  Future<void> initCamera() async {
    final status = await Permission.camera.request();
    if (status != PermissionStatus.granted) {
      state = AsyncValue.error('Permission kamera ditolak', StackTrace.current);
      return;
    }

    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        state = const AsyncValue.data(null);
        return;
      }

      _frontCamera = cameras.firstWhere(
        (c) => c.lensDirection == CameraLensDirection.front,
        orElse: () => cameras.first,
      );

      final controller = CameraController(
        _frontCamera!,
        ResolutionPreset.medium,
        enableAudio: false,
        imageFormatGroup: Platform.isAndroid ? ImageFormatGroup.nv21 : ImageFormatGroup.bgra8888,
      );

      await controller.initialize();
      state = AsyncValue.data(controller);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  CameraDescription? get frontCamera => _frontCamera;

  @override
  void dispose() {
    if (state.hasValue && state.value != null) {
      state.value!.dispose();
    }
    super.dispose();
  }
}
