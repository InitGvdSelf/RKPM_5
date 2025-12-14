import 'package:rkpm_5/core/models/visit_model.dart';
import 'package:rkpm_5/data/datasources/visits/dto/visit_dto.dart';

class VisitMapper {
  static Visit toDomain(VisitDto dto) {
    return Visit.fromJson(dto.toJson());
  }

  static VisitDto toDto(Visit visit) {
    return VisitDto.fromJson(visit.toJson());
  }

  static List<Visit> toDomainList(List<VisitDto> dtos) {
    return dtos.map((dto) => toDomain(dto)).toList();
  }

  static List<VisitDto> toDtoList(List<Visit> visits) {
    return visits.map((visit) => toDto(visit)).toList();
  }
}

