import 'package:dio/dio.dart';
import 'package:rkpm_5/data/datasources/remote/config/api_config.dart';
import 'package:rkpm_5/data/datasources/remote/dadata/dto/dadata_suggest_dto.dart';

/// Remote data source for DaData API (address suggestions and geocoding).
class DadataDataSource {
  final Dio dio;

  DadataDataSource(this.dio);

  /// Get address suggestions while typing.
  /// POST /suggest/address with query.
  Future<List<DadataSuggestionDto>> suggestAddress(String query) async {
    ApiConfig.validateDadataToken();

    try {
      final response = await dio.post(
        '${ApiConfig.dadataBaseUrl}/suggest/address',
        options: Options(
          headers: {
            'Authorization': 'Token ${ApiConfig.dadataToken}',
            'Content-Type': 'application/json',
          },
        ),
        data: {
          'query': query,
          'count': 5,
        },
      );

      final suggestions = response.data['suggestions'] as List?;
      if (suggestions == null) {
        return [];
      }

      return suggestions
          .map((item) => DadataSuggestionDto.fromJson(item as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw Exception('Failed to get address suggestions: ${e.message}');
    }
  }

  /// Geocode address to coordinates.
  /// Uses suggest endpoint and returns first suggestion's coordinates.
  Future<(double lat, double lon, String formatted)> geocode(String address) async {
    ApiConfig.validateDadataToken();

    try {
      final suggestions = await suggestAddress(address);
      if (suggestions.isEmpty) {
        throw Exception('Coordinates not found for address');
      }

      final first = suggestions.first;
      if (first.latitude == null || first.longitude == null) {
        throw Exception('Coordinates not found for address');
      }

      return (first.latitude!, first.longitude!, first.value);
    } catch (e) {
      if (e is Exception && e.toString().contains('Coordinates not found')) {
        rethrow;
      }
      throw Exception('Failed to geocode address: ${e.toString()}');
    }
  }

  /// Reverse geocode coordinates to address.
  /// POST /geolocate/address with lat/lon.
  Future<String> reverseGeocode(double lat, double lon) async {
    ApiConfig.validateDadataToken();

    try {
      final response = await dio.post(
        '${ApiConfig.dadataBaseUrl}/geolocate/address',
        options: Options(
          headers: {
            'Authorization': 'Token ${ApiConfig.dadataToken}',
            'Content-Type': 'application/json',
          },
        ),
        data: {
          'lat': lat,
          'lon': lon,
          'count': 1,
        },
      );

      final suggestions = response.data['suggestions'] as List?;
      if (suggestions == null || suggestions.isEmpty) {
        throw Exception('Address not found for coordinates');
      }

      final first = suggestions.first as Map<String, dynamic>;
      return first['value'] as String? ?? 'Адрес не найден';
    } on DioException catch (e) {
      throw Exception('Failed to reverse geocode: ${e.message}');
    }
  }
}

