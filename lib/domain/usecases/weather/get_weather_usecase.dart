import 'package:rkpm_5/data/datasources/remote/api/weather_datasource.dart';
import 'package:rkpm_5/data/datasources/remote/mappers/weather_mapper.dart';
import 'package:rkpm_5/core/models/weather.dart';

class GetWeatherUseCase {
  final WeatherDataSource dataSource;

  GetWeatherUseCase(this.dataSource);

  Future<Weather> execute(String city) async {
    final trimmed = city.trim();
    if (trimmed.isEmpty) {
      throw ArgumentError('City must not be empty');
    }

    final dto = await dataSource.getCurrentWeather(city: trimmed, units: 'metric', lang: 'en');
    return dto.toModel();
  }
}
