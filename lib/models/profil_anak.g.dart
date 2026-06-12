// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profil_anak.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProfilAnakAdapter extends TypeAdapter<ProfilAnak> {
  @override
  final int typeId = 0;

  @override
  ProfilAnak read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProfilAnak(
      id: fields[0] as String,
      nama: fields[1] as String,
      kondisi: fields[2] as String,
      usia: fields[3] as int,
      mode: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ProfilAnak obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.nama)
      ..writeByte(2)
      ..write(obj.kondisi)
      ..writeByte(3)
      ..write(obj.usia)
      ..writeByte(4)
      ..write(obj.mode);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProfilAnakAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
