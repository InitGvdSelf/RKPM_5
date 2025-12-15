/// DTO for openFDA drug information response.
class OpenFdaDrugDto {
  final String? brandName;
  final String? genericName;
  final String? indicationsAndUsage;
  final String? warnings;

  const OpenFdaDrugDto({
    this.brandName,
    this.genericName,
    this.indicationsAndUsage,
    this.warnings,
  });

  factory OpenFdaDrugDto.fromJson(Map<String, dynamic> json) {
    final results = json['results'] as List?;
    if (results == null || results.isEmpty) {
      return const OpenFdaDrugDto();
    }

    final first = results.first as Map<String, dynamic>;
    final openfda = first['openfda'] as Map<String, dynamic>?;
    final brandNames = openfda?['brand_name'] as List?;
    final genericNames = openfda?['generic_name'] as List?;

    String? extractFirst(List? list) {
      if (list != null && list.isNotEmpty) {
        return list.first.toString();
      }
      return null;
    }

    String? extractString(Map<String, dynamic>? map, String key) {
      if (map == null) return null;
      final value = map[key];
      if (value is List && value.isNotEmpty) {
        return value.first.toString();
      }
      if (value is String && value.isNotEmpty) {
        return value;
      }
      return null;
    }

    return OpenFdaDrugDto(
      brandName: extractFirst(brandNames),
      genericName: extractFirst(genericNames),
      indicationsAndUsage: extractString(first, 'indications_and_usage'),
      warnings: extractString(first, 'warnings'),
    );
  }
}

