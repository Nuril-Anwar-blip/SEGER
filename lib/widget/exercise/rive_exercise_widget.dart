import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rive/rive.dart';
import '../../controllers/rive_bone_controller.dart';
import '../../providers/rive_bone_provider.dart';

class RiveExerciseWidget extends ConsumerStatefulWidget {
  const RiveExerciseWidget({super.key});

  @override
  ConsumerState<RiveExerciseWidget> createState() => _RiveExerciseWidgetState();
}

class _RiveExerciseWidgetState extends ConsumerState<RiveExerciseWidget> {
  final _boneController = RiveBoneController();

  void _onRiveInit(Artboard artboard) {

    // Debug: cetak semua komponen dan state machine yang tersedia
    debugPrint('=== RIVE COMPONENTS ===');
    artboard.forEachComponent((child) {
      debugPrint('  Component: "${child.name}" (${child.runtimeType})');
    });


    // 2. Coba attach state machine apapun yang tersedia (untuk animasi idle seperti kedip mata)
    StateMachineController? smController;

    // Coba beberapa nama umum
    for (final smName in ['State Machine 1', 'StateMachine', 'Main', 'Idle']) {
      smController = StateMachineController.fromArtboard(artboard, smName);
      if (smController != null) {
        debugPrint('✅ State Machine ditemukan: "$smName"');
        break;
      }
    }

    // Fallback: coba nama default
    if (smController == null) {
      for (final animation in artboard.animations) {
        debugPrint('  Animation: "${animation.name}" (${animation.runtimeType})');
      }
    }

    if (smController != null) {
      artboard.addController(smController);
    } else {
      // Tidak ada state machine — fallback ke SimpleAnimation
      debugPrint('⚠️ Tidak ada State Machine. Mencoba SimpleAnimation...');
      for (final animation in artboard.animations) {
        debugPrint('  Mencoba animasi: "${animation.name}"');
        final simple = SimpleAnimation(animation.name);
        artboard.addController(simple);
        debugPrint('✅ SimpleAnimation "${animation.name}" berhasil di-attach');
        break; // ambil yang pertama saja
      }
    }

    // 3. Tambahkan custom RiveBoneController di akhir
    // Penting: controller ini HARUS ditambahkan terakhir agar method apply()-nya
    // dieksekusi setelah state machine/animasi, sehingga rotasi manual kita tidak
    // ditimpa kembali oleh animasi bawaan (idle).
    artboard.addController(_boneController);

    // 4. Mulai Auto Debug / Radar Bone Test
    _boneController.startAutoDebug();
  }

  @override
  Widget build(BuildContext context) {
    // ref.listen(rivePoseStateProvider, (previous, next) {
    //   if (next.isPoseDetected) {
    //     // Hanya update referensi datanya, apply() akan dilakukan tiap frame oleh Rive
    //     // _boneController.updatePoseState(next); // Dimatikan sementara untuk Radar Test
    //   }
    // });

    return RiveAnimation.asset(
      'assets/rive/24876-46460-interactive-bunny-character.riv',
      fit: BoxFit.contain,
      onInit: _onRiveInit,
    );
  }
}
