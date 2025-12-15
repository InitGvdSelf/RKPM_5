/// DTO for DaData address suggestion response.
class DadataSuggestionDto {
  final String value;
  final double? latitude;
  final double? longitude;

  const DadataSuggestionDto({
    required this.value,
    this.latitude,
    this.longitude,
  });

  factory DadataSuggestionDto.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>?;
    final geoLat = data?['geo_lat'];
    final geoLon = data?['geo_lon'];

    return DadataSuggestionDto(
      value: json['value'] as String? ?? '',
      latitude: geoLat != null ? double.tryParse(geoLat.toString()) : null,
      longitude: geoLon != null ? double.tryParse(geoLon.toString()) : null,
    );
  }
}

