// GENERATED CODE - DO NOT MODIFY BY HAND
// This file is included in the bundle so the project compiles without running build_runner.
// If you run build_runner, it will regenerate this file.

part of 'weather_dto.dart';

WeatherDTO _$WeatherDTOFromJson(Map<String, dynamic> json) => WeatherDTO(
      coord: json['coord'] == null
          ? null
          : Coord.fromJson(Map<String, dynamic>.from(json['coord'] as Map)),
      weather: (json['weather'] as List<dynamic>?)
          ?.map((e) => WeatherInfo.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList(),
      main: json['main'] == null
          ? null
          : MainInfo.fromJson(Map<String, dynamic>.from(json['main'] as Map)),
      wind: json['wind'] == null
          ? null
          : WindInfo.fromJson(Map<String, dynamic>.from(json['wind'] as Map)),
      clouds: json['clouds'] == null
          ? null
          : CloudsInfo.fromJson(Map<String, dynamic>.from(json['clouds'] as Map)),
      sys: json['sys'] == null
          ? null
          : SysInfo.fromJson(Map<String, dynamic>.from(json['sys'] as Map)),
      dt: (json['dt'] as num?)?.toInt(),
      name: json['name'] as String?,
    );

Map<String, dynamic> _$WeatherDTOToJson(WeatherDTO instance) => <String, dynamic>{
      'coord': instance.coord?.toJson(),
      'weather': instance.weather?.map((e) => e.toJson()).toList(),
      'main': instance.main?.toJson(),
      'wind': instance.wind?.toJson(),
      'clouds': instance.clouds?.toJson(),
      'sys': instance.sys?.toJson(),
      'dt': instance.dt,
      'name': instance.name,
    };

Coord _$CoordFromJson(Map<String, dynamic> json) => Coord(
      lon: (json['lon'] as num?)?.toDouble(),
      lat: (json['lat'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$CoordToJson(Coord instance) => <String, dynamic>{
      'lon': instance.lon,
      'lat': instance.lat,
    };

WeatherInfo _$WeatherInfoFromJson(Map<String, dynamic> json) => WeatherInfo(
      id: (json['id'] as num?)?.toInt(),
      main: json['main'] as String?,
      description: json['description'] as String?,
      icon: json['icon'] as String?,
    );

Map<String, dynamic> _$WeatherInfoToJson(WeatherInfo instance) => <String, dynamic>{
      'id': instance.id,
      'main': instance.main,
      'description': instance.description,
      'icon': instance.icon,
    };

MainInfo _$MainInfoFromJson(Map<String, dynamic> json) => MainInfo(
      temp: (json['temp'] as num?)?.toDouble(),
      feelsLike: (json['feels_like'] as num?)?.toDouble(),
      tempMin: (json['temp_min'] as num?)?.toDouble(),
      tempMax: (json['temp_max'] as num?)?.toDouble(),
      pressure: (json['pressure'] as num?)?.toInt(),
      humidity: (json['humidity'] as num?)?.toInt(),
    );

Map<String, dynamic> _$MainInfoToJson(MainInfo instance) => <String, dynamic>{
      'temp': instance.temp,
      'feels_like': instance.feelsLike,
      'temp_min': instance.tempMin,
      'temp_max': instance.tempMax,
      'pressure': instance.pressure,
      'humidity': instance.humidity,
    };

WindInfo _$WindInfoFromJson(Map<String, dynamic> json) => WindInfo(
      speed: (json['speed'] as num?)?.toDouble(),
      deg: (json['deg'] as num?)?.toInt(),
      gust: (json['gust'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$WindInfoToJson(WindInfo instance) => <String, dynamic>{
      'speed': instance.speed,
      'deg': instance.deg,
      'gust': instance.gust,
    };

CloudsInfo _$CloudsInfoFromJson(Map<String, dynamic> json) => CloudsInfo(
      all: (json['all'] as num?)?.toInt(),
    );

Map<String, dynamic> _$CloudsInfoToJson(CloudsInfo instance) => <String, dynamic>{
      'all': instance.all,
    };

SysInfo _$SysInfoFromJson(Map<String, dynamic> json) => SysInfo(
      country: json['country'] as String?,
      sunrise: (json['sunrise'] as num?)?.toInt(),
      sunset: (json['sunset'] as num?)?.toInt(),
    );

Map<String, dynamic> _$SysInfoToJson(SysInfo instance) => <String, dynamic>{
      'country': instance.country,
      'sunrise': instance.sunrise,
      'sunset': instance.sunset,
    };
