import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:rive/rive.dart';
// Import Bone explicitly since it's an internal class not exported by default rive.dart
import 'package:rive/src/rive_core/bones/bone.dart';

class RiveBoneController extends RiveAnimationController<RuntimeArtboard> {
  // 1. Variabel privat List<Bone> (RuntimeBone di Rive 0.13.x menggunakan nama 'Bone')
  final List<Bone> _allBones = [];
  
  Timer? _debugTimer;
  int _currentIndex = -1;

  @override
  bool init(RuntimeArtboard artboard) {
    _allBones.clear();
    
    // 2. Kumpulkan semua tulang ke dalam list
    // Menggunakan forEachComponent karena artboard.components tidak tersedia di versi ini
    artboard.forEachComponent((child) {
      if (child is Bone) {
        _allBones.add(child);
      }
    });

    // 3. Cetak total tulang yang ditemukan
    debugPrint('🔍 Total Bone ditemukan: ${_allBones.length}');
    
    isActive = true;
    return true;
  }

  @override
  void apply(RuntimeArtboard artboard, double elapsedSeconds) {
    // Agar rotasi manual kita tidak ditimpa oleh animasi bawaan (idle),
    // kita harus MENG-ENFORCE rotasi di sini setiap frame.
    
    if (_currentIndex >= 0 && _currentIndex < _allBones.length) {
      // b. Reset rotasi semua tulang ke 0.0
      for (final bone in _allBones) {
        bone.rotation = 0.0;
      }
      // c. Putar tulang aktif sebesar 1.57 radian (90 derajat)
      _allBones[_currentIndex].rotation = 1.57;
    }
  }

  // 4. Fungsi startAutoDebug menggunakan Timer.periodic
  void startAutoDebug() {
    if (_allBones.isEmpty) {
      debugPrint('⚠️ Tidak bisa memulai Radar Bone, _allBones kosong!');
      return;
    }

    _currentIndex = 0;
    _debugTimer?.cancel();
    
    debugPrint('🚀 Memulai Radar Bone Testing...');

    _debugTimer = Timer.periodic(const Duration(milliseconds: 2500), (timer) {
      // e. Hentikan Timer jika sudah mencapai indeks terakhir
      if (_currentIndex >= _allBones.length) {
        timer.cancel();
        debugPrint('✅ Radar Bone selesai.');
        return;
      }

      // d. Cetak pesan debug
      debugPrint('🔍 [RADAR BONE] Menggerakkan Tulang Indeks Ke: $_currentIndex');

      // Pindah ke indeks berikutnya untuk rotasi di apply()
      _currentIndex++;
    });
  }

  void stopAutoDebug() {
    _debugTimer?.cancel();
    _debugTimer = null;
    _currentIndex = -1;
  }
}
