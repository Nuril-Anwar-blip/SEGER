import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/pose_frame.dart';
import '../services/pose_isolate_service.dart';

final poseServiceProvider = Provider<PoseIsolateService>((ref) {
  final service = PoseIsolateService();
  ref.onDispose(() => service.dispose());
  return service;
});

final poseStreamProvider = StreamProvider<PoseFrame>((ref) {
  final service = ref.watch(poseServiceProvider);
  return service.poseStream;
});

final isPausedProvider = StateProvider<bool>((ref) => false);
