// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserProfileAdapter extends TypeAdapter<UserProfile> {
  @override
  final int typeId = 0;

  @override
  UserProfile read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserProfile(
      userId: fields[0] as String,
      pseudonyme: fields[1] as String,
      avatar: fields[2] as String,
      xp: fields[3] as int,
      niveau: fields[4] as int,
      badges: (fields[5] as List).cast<Badge>(),
      blocks: (fields[6] as List).cast<BlockData>(),
      loot: (fields[7] as List).cast<LootItem>(),
      stats: fields[8] as Stats,
      nodeId: fields[9] as String,
      completedUniqueQuestIds: (fields[10] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, UserProfile obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.userId)
      ..writeByte(1)
      ..write(obj.pseudonyme)
      ..writeByte(2)
      ..write(obj.avatar)
      ..writeByte(3)
      ..write(obj.xp)
      ..writeByte(4)
      ..write(obj.niveau)
      ..writeByte(5)
      ..write(obj.badges)
      ..writeByte(6)
      ..write(obj.blocks)
      ..writeByte(7)
      ..write(obj.loot)
      ..writeByte(8)
      ..write(obj.stats)
      ..writeByte(9)
      ..write(obj.nodeId)
      ..writeByte(10)
      ..write(obj.completedUniqueQuestIds);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserProfileAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
