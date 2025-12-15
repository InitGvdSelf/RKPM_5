import 'package:dio/dio.dart';
import 'package:rkpm_5/data/datasources/remote/api/dio_client_with_interceptors.dart';
import 'package:rkpm_5/data/datasources/remote/dto/weather_dto.dart';

class WeatherDataSource {
  final DioClientWithInterceptors client;

  WeatherDataSource(this.client);

  Future<WeatherDTO> getCurrentWeather({
    required String city,
    String units = 'metric',
    String lang = 'en',
  }) async {
    final Response<dynamic> res = await client.get<dynamic>(
      '/weather',
      queryParameters: {
        'q': city,
        'units': units,
        'lang': lang,
      },
    );

    // OpenWeatherMap returns JSON object
    final data = res.data;
    if (data is Map<String, dynamic>) {
      return WeatherDTO.fromJson(data);
    }
    if (data is Map) {
      return WeatherDTO.fromJson(Map<String, dynamic>.from(data));
    }
    throw FormatException('Unexpected response format: ${data.runtimeType}');
  }

  /// NOTE: OpenWeatherMap 5 day forecast is /forecast. To keep the методичка method name,
  /// we return a list of WeatherDTO items parsed from "list".
  Future<List<WeatherDTO>> getFiveDayForecast({
    required String city,
    String units = 'metric',
    String lang = 'en',
  }) async {
    final Response<dynamic> res = await client.get<dynamic>(
      '/forecast',
      queryParameters: {
        'q': city,
        'units': units,
        'lang': lang,
      },
    );

    final data = res.data;
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
