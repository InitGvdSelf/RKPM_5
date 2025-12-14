import 'package:rkpm_5/core/models/diary_entry_model.dart';
import 'package:rkpm_5/data/datasources/diary/dto/diary_entry_dto.dart';

class DiaryEntryMapper {
  static DiaryEntry toDomain(DiaryEntryDto dto) {
    return DiaryEntry.fromJson(dto.toJson());
  }

  static DiaryEntryDto toDto(DiaryEntry entry) {
    return DiaryEntryDto.fromJson(entry.toJson());
  }

  static List<DiaryEntry> toDomainList(List<DiaryEntryDto> dtos) {
    return dtos.map((dto) => toDomain(dto)).toList();
  }

  static List<DiaryEntryDto> toDtoList(List<DiaryEntry> entries) {
    return entries.map((entry) => toDto(entry)).toList();
  }
}

