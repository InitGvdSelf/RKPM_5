class Weather {
  final String city;
  final String? country;
  final String? description;

  final double? temperatureC;
  final double? feelsLikeC;
  final int? humidity;
  final double? windSpeed;

  final DateTime? sunrise;
  final DateTime? sunset;
  final DateTime updatedAt;

  Weather({
    required this.city,
    required this.updatedAt,
    this.country,
    this.description,
    this.temperatureC,
    this.feelsLikeC,
    this.humidity,
    this.windSpeed,
    this.sunrise,
    this.sunset,
  });

  String get temperatureFormatted {
    if (temperatureC == null) return '—';
    return '${temperatureC!.toStringAsFixed(1)} °C';
  }

  String get feelsLikeFormatted {
    if (feelsLikeC == null) return '—';
    return '${feelsLikeC!.toStringAsFixed(1)} °C';
  }

  bool get isDaytime {
    if (sunrise == null || sunset == null) return true;
    final now = DateTime.now();
    return now.isAfter(sunrise!) && now.isBefore(sunset!);
  }
}
