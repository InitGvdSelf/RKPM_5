import 'package:rkpm_5/core/models/drug_info_model.dart';
import 'package:rkpm_5/data/datasources/remote/openfda/dto/openfda_drug_dto.dart';

/// Mapper from openFDA DTO to domain DrugInfo model.
class OpenFdaMapper {
  static DrugInfo? toDomain(OpenFdaDrugDto? dto) {
    if (dto == null) return null;

    final title = dto.brandName ?? dto.genericName ?? 'Лекарство';
    if (title == 'Лекарство' &&
        dto.indicationsAndUsage == null &&
        dto.warnings == null) {
      return null;
    }

    return DrugInfo(
      title: title,
      indications: dto.indicationsAndUsage,
      warnings: dto.warnings,
    );
  }
}

