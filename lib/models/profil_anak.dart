import 'package:hive/hive.dart';

part 'profil_anak.g.dart';

@HiveType(typeId: 0)
class ProfilAnak extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String nama;

  @HiveField(2)
  final String kondisi;

  @HiveField(3)
  final int usia;

  @HiveField(4)
  final String mode;

  ProfilAnak({
    required this.id,
    required this.nama,
    required this.kondisi,
    required this.usia,
    this.mode = "guided",
  });
}
