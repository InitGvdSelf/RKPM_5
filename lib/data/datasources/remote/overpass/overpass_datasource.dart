import 'package:dio/dio.dart';
import 'package:rkpm_5/data/datasources/remote/config/api_config.dart';
import 'package:rkpm_5/data/datasources/remote/overpass/dto/overpass_response_dto.dart';

/// Remote data source for Overpass API (OpenStreetMap queries).
class OverpassDataSource {
  final Dio dio;

  OverpassDataSource(this.dio);

  /// Find pharmacies near coordinates within radius.
  /// POST /interpreter with Overpass QL query.
  Future<List<OverpassElementDto>> pharmaciesNearby(
    double lat,
    double lon,
    int radiusMeters,
  ) async {
    try {
      // Overpass QL query: find pharmacies (amenity=pharmacy) around coordinates
      final query = '''
[out:json][timeout:25];
(
  node["amenity"="pharmacy"](around:$radiusMeters,$lat,$lon);
  way["amenity"="pharmacy"](around:$radiusMeters,$lat,$lon);
  relation["amenity"="pharmacy"](around:$radiusMeters,$lat,$lon);
);
out body;
>;
out skel qt;
''';

      final response = await dio.post(
        '${ApiConfig.overpassBaseUrl}/interpreter',
        data: query,
        options: Options(
          contentType: 'text/plain',
          sendTimeout: const Duration(seconds: 30),
        ),
      );

      final elements = response.data['elements'] as List?;
      if (elements == null) {
        return [];
      }

      return elements
          .map((item) => OverpassElementDto.fromJson(item as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw Exception('Failed to find pharmacies nearby: ${e.message}');
    }
  }

  /// Get pharmacy details by OSM element type and ID.
  /// Query by exact element id and return its tags.
  Future<OverpassElementDto?> pharmacyDetails(String osmType, String osmId) async {
    try {
      final id = int.tryParse(osmId);
      if (id == null) {
        return null;
      }

      // Overpass QL query: get specific element by type and id
      final query = '''
[out:json][timeout:25];
$osmType($id);
out body;
''';

      final response = await dio.post(
        '${ApiConfig.overpassBaseUrl}/interpreter',
        data: query,
        options: Options(
          contentType: 'text/plain',
          sendTimeout: const Duration(seconds: 30),
        ),
      );

      final elements = response.data['elements'] as List?;
      if (elements == null || elements.isEmpty) {
        return null;
      }

      return OverpassElementDto.fromJson(elements.first as Map<String, dynamic>);
    } on DioException catch (e) {
      throw Exception('Failed to get pharmacy details: ${e.message}');
    }
  }
}

