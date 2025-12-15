import 'package:rkpm_5/core/models/weather.dart';
import 'package:rkpm_5/data/datasources/remote/dto/weather_dto.dart';

extension WeatherDTOMapper on WeatherDTO {
  Weather toModel() {
    final info = (weather != null && weather!.isNotEmpty) ? weather!.first : null;

    final sunrise = sys?.sunrise != null
        ? DateTime.fromMillisecondsSinceEpoch(sys!.sunrise! * 1000, isUtc: true).toLocal()
        : null;
    final sunset = sys?.sunset != null
        ? DateTime.fromMillisecondsSinceEpoch(sys!.sunset! * 1000, isUtc: true).toLocal()
        : null;

    final updatedAt = dt != null
        ? DateTime.fromMillisecondsSinceEpoch(dt! * 1000, isUtc: true).toLocal()
        : DateTime.now();

    return Weather(
      city: name ?? '',
      country: sys?.country,
      description: info?.description ?? info?.main,
      temperatureC: main?.temp,
      feelsLikeC: main?.feelsLike,
      humidity: main?.humidity,
      windSpeed: wind?.speed,
      sunrise: sunrise,
      sunset: sunset,
      updatedAt: updatedAt,
    );
  }
}
