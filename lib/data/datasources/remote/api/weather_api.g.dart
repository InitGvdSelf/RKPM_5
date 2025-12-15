// GENERATED CODE - DO NOT MODIFY BY HAND
// This file is intentionally included so the project builds without running build_runner.
// You can re-generate it with:
//   dart run build_runner build --delete-conflicting-outputs

part of 'weather_api.dart';

class _WeatherApi implements WeatherApi {
  _WeatherApi(
    this._dio, {
    this.baseUrl,
  });

  final Dio _dio;

  String? baseUrl;

  @override
  Future<WeatherDTO> getCurrentWeather(
    String city, {
    String units = 'metric',
    String lang = 'en',
  }) async {
    final queryParameters = <String, dynamic>{'q': city, 'units': units, 'lang': lang};
    final options = Options(method: 'GET');
    final Response<dynamic> result = await _dio.fetch<dynamic>(
      options.compose(
        _dio.options,
        '/weather',
        queryParameters: queryParameters,
      ).copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl),
    );
    final value = WeatherDTO.fromJson(Map<String, dynamic>.from(result.data as Map));
    return value;
  }

  @override
  Future<List<WeatherDTO>> getFiveDayForecast(
    String city, {
    String units = 'metric',
    String lang = 'en',
  }) async {
    final queryParameters = <String, dynamic>{'q': city, 'units': units, 'lang': lang};
    final options = Options(method: 'GET');
    final Response<dynamic> result = await _dio.fetch<dynamic>(
      options.compose(
        _dio.options,
        '/forecast',
        queryParameters: queryParameters,
      ).copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl),
    );

    final data = result.data;
    if (data is Map) {
      final map = Map<String, dynamic>.from(data);
      final list = map['list'];
      if (list is List) {
        return list
            .whereType<Map>()
            .map((e) => WeatherDTO.fromJson(Map<String, dynamic>.from(e)))
            .toList();
      }
    }
    throw FormatException('Unexpected forecast format');
  }
}
