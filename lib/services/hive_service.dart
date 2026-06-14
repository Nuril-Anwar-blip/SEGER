import 'package:hive_flutter/hive_flutter.dart';
import '../models/profil_anak.dart';

class HiveService {
  static const String boxProfil = 'profil_anak';

  static Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(ProfilAnakAdapter());
    await Hive.openBox<ProfilAnak>(boxProfil);
  }

  static Box<ProfilAnak> get profilBox => Hive.box<ProfilAnak>(boxProfil);

  static Future<void> saveProfil(ProfilAnak profil) async {
    await profilBox.put('current_profil', profil);
  }

  static ProfilAnak? getCurrentProfil() {
    return profilBox.get('current_profil');
  }
}
