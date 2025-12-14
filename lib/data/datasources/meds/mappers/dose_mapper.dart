import 'package:rkpm_5/core/models/medicine_model.dart';
import 'package:rkpm_5/data/datasources/meds/dto/dose_dto.dart';

class DoseMapper {
  static DoseEntry toDomain(DoseDto dto) {
    return DoseEntry.fromJson(dto.toJson());
  }

  static DoseDto toDto(DoseEntry entry) {
    return DoseDto.fromJson(entry.toJson());
  }

  static List<DoseEntry> toDomainList(List<DoseDto> dtos) {
    return dtos.map((dto) => toDomain(dto)).toList();
  }

  static List<DoseDto> toDtoList(List<DoseEntry> entries) {
    return entries.map((entry) => toDto(entry)).toList();
  }
}

