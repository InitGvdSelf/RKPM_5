import 'package:rkpm_5/core/models/pharmacy_model.dart';
import 'package:rkpm_5/data/datasources/pharmacies/dto/pharmacy_dto.dart';

class PharmacyMapper {
  static Pharmacy toDomain(PharmacyDto dto) {
    return Pharmacy.fromJson(dto.toJson());
  }

  static PharmacyDto toDto(Pharmacy pharmacy) {
    return PharmacyDto.fromJson(pharmacy.toJson());
  }

  static List<Pharmacy> toDomainList(List<PharmacyDto> dtos) {
    return dtos.map((dto) => toDomain(dto)).toList();
  }

  static List<PharmacyDto> toDtoList(List<Pharmacy> pharmacies) {
    return pharmacies.map((pharmacy) => toDto(pharmacy)).toList();
  }
}

