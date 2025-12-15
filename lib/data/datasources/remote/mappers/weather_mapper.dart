import 'package:rkpm_5/core/models/weather.dart';
import 'package:rkpm_5/data/datasources/remote/dto/weather_dto.dart';

extension WeatherDtoMapper on WeatherDTO {
  Weather toModel() {
    return Weather(
      city: name ?? '',
      country: sys?.country,
      temperatureC: main?.temp,
      feelsLikeC: main?.feelsLike,
      humidity: main?.humidity,
      windSpeed: wind?.speed,
      description: (weather != null && weather!.isNotEmpty) ? weather!.first.description : null,
      sunrise: sys?.sunrise != null
          ? DateTime.fromMillisecondsSinceEpoch((sys!.sunrise! * 1000).toInt())
          : null,
      sunset: sys?.sunset != null
          ? DateTime.fromMillisecondsSinceEpoch((sys!.sunset! * 1000).toInt())
          : null,
      updatedAt: DateTime.now(),
    );
  }
}