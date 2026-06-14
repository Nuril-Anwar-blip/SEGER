import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/profil_anak.dart';

class HiveService {
  static const String boxProfil = 'profil_anak';
  static bool _isInitialized = false;

  static Future<void> init() async {
    if (_isInitialized) return;

    await Hive.initFlutter();

    // Hanya register adapter jika belum pernah di-register
    if (!Hive.isAdapterRegistered(ProfilAnakAdapter().typeId)) {
      Hive.registerAdapter(ProfilAnakAdapter());
    }

    await Hive.openBox<ProfilAnak>(boxProfil);
    _isInitialized = true;
    debugPrint('✅ HiveService initialized');
  }

  static Box<ProfilAnak> get profilBox {
    if (!Hive.isBoxOpen(boxProfil)) {
      throw StateError('HiveService: Box "$boxProfil" belum dibuka. Panggil HiveService.init() dulu.');
    }
    return Hive.box<ProfilAnak>(boxProfil);
  }

  static Future<void> saveProfil(ProfilAnak profil) async {
    try {
      final box = profilBox;
      await box.put('current_profil', profil);
      // Pastikan data tertulis ke disk
      await box.flush();
      debugPrint('✅ Profil tersimpan: ${profil.nama}, usia ${profil.usia}, kondisi ${profil.kondisi}');
    } catch (e) {
      debugPrint('❌ Gagal menyimpan profil: $e');
      rethrow;
    }
  }

  static ProfilAnak? getCurrentProfil() {
    try {
      return profilBox.get('current_profil');
    } catch (e) {
      debugPrint('❌ Gagal membaca profil: $e');
      return null;
    }
  }

  /// Hapus semua data profil (untuk reset / ganti profil)
  static Future<void> clearProfil() async {
    try {
      await profilBox.clear();
      debugPrint('✅ Profil dihapus');
    } catch (e) {
      debugPrint('❌ Gagal menghapus profil: $e');
    }
  }
}