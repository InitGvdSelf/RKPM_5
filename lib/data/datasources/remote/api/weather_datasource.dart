import 'package:rkpm_5/data/datasources/remote/api/weather_api.dart';
import 'package:rkpm_5/data/datasources/remote/dto/weather_dto.dart';

class WeatherDataSource {
  final WeatherApi api;

  WeatherDataSource(this.api);

  Future<WeatherDTO> getCurrentWeather({
    required String city,
    String units = 'metric',
    String lang = 'en',
  }) {
    return api.getCurrentWeather(
      city,
      units: units,
      lang: lang,
    );
  }

  Future<List<WeatherDTO>> getFiveDayForecast({
    required String city,
    String units = 'metric',
    String lang = 'en',
  }) {
    return api.getFiveDayForecast(
      city,
      units: units,
      lang: lang,
    );
  }
}