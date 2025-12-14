import 'package:rkpm_5/core/models/medicine_model.dart';
import 'package:rkpm_5/data/datasources/meds/dto/medicine_dto.dart';

class MedicineMapper {
  static Medicine toDomain(MedicineDto dto) {
    return Medicine.fromJson(dto.toJson());
  }

  static MedicineDto toDto(Medicine medicine) {
    return MedicineDto.fromJson(medicine.toJson());
  }

  static List<Medicine> toDomainList(List<MedicineDto> dtos) {
    return dtos.map((dto) => toDomain(dto)).toList();
  }

  static List<MedicineDto> toDtoList(List<Medicine> medicines) {
    return medicines.map((med) => toDto(med)).toList();
  }
}

