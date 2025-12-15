/// DTO for Overpass API response element.
class OverpassElementDto {
  final String type; // 'node', 'way', or 'relation'
  final int id;
  final double? lat;
  final double? lon;
  final Map<String, String> tags;

  const OverpassElementDto({
    required this.type,
    required this.id,
    this.lat,
    this.lon,
    required this.tags,
  });

  /// Get element identity string: "type:id"
  String get idString => '$type:$id';

  factory OverpassElementDto.fromJson(Map<String, dynamic> json) {
    final tags = <String, String>{};
    if (json['tags'] != null) {
      final tagsMap = json['tags'] as Map<String, dynamic>;
      tagsMap.forEach((key, value) {
        if (value != null) {
          tags[key] = value.toString();
        }
      });
    }

    return OverpassElementDto(
      type: json['type'] as String? ?? '',
      id: json['id'] as int? ?? 0,
      lat: json['lat'] != null ? (json['lat'] as num).toDouble() : null,
      lon: json['lon'] != null ? (json['lon'] as num).toDouble() : null,
      tags: tags,
    );
  }
}

