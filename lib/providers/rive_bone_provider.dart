import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/pose_frame.dart';
import '../models/rive_bone_transform.dart';
import '../core/utils/pose_math_utils.dart';
import 'pose_provider.dart';

final rivePoseStateProvider = Provider<RivePoseState>((ref) {
  final poseAsync = ref.watch(poseStreamProvider);

  return poseAsync.when(
    data: (poseFrame) {
      final transforms = PoseToBoneMapper.map(poseFrame);
      return RivePoseState(
        transforms: transforms,
        matchScore: poseFrame.matchScore,
        attentionScore: poseFrame.attentionScore,
        isPoseDetected: true,
      );
    },
    loading: () => RivePoseState(transforms: []),
    error: (_, __) => RivePoseState(transforms: []),
  );
});

class PoseToBoneMapper {
  static List<BoneTransform> map(PoseFrame frame) {
    final lm = frame.landmarks;
    final List<BoneTransform> transforms = [];

    // --- ROTATION BONES ---
    final rKnee = lm['rightKnee'];
    final rAnkle = lm['rightAnkle'];
    if (rKnee != null && rAnkle != null) {
      transforms.add(BoneTransform(
        boneName: 'atas_kaki_kanan',
        rotation: PoseMathUtils.angleBetween(rKnee, rAnkle),
      ));
    }

    final lKnee = lm['leftKnee'];
    final lAnkle = lm['leftAnkle'];
    if (lKnee != null && lAnkle != null) {
      transforms.add(BoneTransform(
        boneName: 'atas_kaki_kiri',
        rotation: PoseMathUtils.angleBetween(lKnee, lAnkle),
      ));
    }

    final rShoulder = lm['rightShoulder'];
    final rElbow = lm['rightElbow'];
    if (rShoulder != null && rElbow != null) {
      transforms.add(BoneTransform(
        boneName: 'atas_tangan_kanan',
        rotation: PoseMathUtils.angleBetween(rShoulder, rElbow),
      ));
    }

    final rWrist = lm['rightWrist'];
    if (rElbow != null && rWrist != null) {
      transforms.add(BoneTransform(
        boneName: 'bawah_tangan_kanan',
        rotation: PoseMathUtils.angleBetween(rElbow, rWrist),
      ));
    }

    final lShoulder = lm['leftShoulder'];
    final lElbow = lm['leftElbow'];
    if (lShoulder != null && lElbow != null) {
      transforms.add(BoneTransform(
        boneName: 'atas_tangan_kiri',
        rotation: PoseMathUtils.angleBetween(lShoulder, lElbow),
      ));
    }

    final lWrist = lm['leftWrist'];
    if (lElbow != null && lWrist != null) {
      transforms.add(BoneTransform(
        boneName: 'bawah_tangan_kiri',
        rotation: PoseMathUtils.angleBetween(lElbow, lWrist),
      ));
    }

    // --- TRANSLATION NODES ---
    // Note: X and Y are normalized (0.0 to 1.0). Scaling to artboard size
    // will be handled inside the RiveBoneController.
    if (rAnkle != null) {
      transforms.add(BoneTransform(
        boneName: 'bawah_kaki_kanan',
        translationX: rAnkle.x,
        translationY: rAnkle.y,
      ));
    }

    if (lAnkle != null) {
      transforms.add(BoneTransform(
        boneName: 'bawah_kaki_kiri',
        translationX: lAnkle.x,
        translationY: lAnkle.y,
      ));
    }

    final lHip = lm['leftHip'];
    final rHip = lm['rightHip'];
    if (lHip != null && rHip != null) {
      transforms.add(BoneTransform(
        boneName: 'pinggang',
        translationX: (lHip.x + rHip.x) / 2,
        translationY: (lHip.y + rHip.y) / 2,
      ));
    }

    final nose = lm['nose'];
    if (nose != null) {
      transforms.add(BoneTransform(
        boneName: 'Kepala',
        translationX: nose.x,
        translationY: nose.y,
      ));
    }

    return transforms;
  }
}
