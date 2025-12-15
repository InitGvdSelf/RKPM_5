import 'package:json_annotation/json_annotation.dart';

part 'weather_dto.g.dart';

@JsonSerializable()
class WeatherDTO {
  final Coord? coord;
  final List<WeatherInfo>? weather;
  final MainInfo? main;
  final WindInfo? wind;
  final CloudsInfo? clouds;
  final SysInfo? sys;

  final int? dt;
  final String? name;

  WeatherDTO({
    this.coord,
    this.weather,
    this.main,
    this.wind,
    this.clouds,
    this.sys,
    this.dt,
    this.name,
  });

  factory WeatherDTO.fromJson(Map<String, dynamic> json) => _$WeatherDTOFromJson(json);
  Map<String, dynamic> toJson() => _$WeatherDTOToJson(this);
}

@JsonSerializable()
class Coord {
  final double? lon;
  final double? lat;

  Coord({this.lon, this.lat});

  factory Coord.fromJson(Map<String, dynamic> json) => _$CoordFromJson(json);
  Map<String, dynamic> toJson() => _$CoordToJson(this);
}

@JsonSerializable()
class WeatherInfo {
  final int? id;
  final String? main;
  final String? description;
  final String? icon;

  WeatherInfo({this.id, this.main, this.description, this.icon});

  factory WeatherInfo.fromJson(Map<String, dynamic> json) => _$WeatherInfoFromJson(json);
  Map<String, dynamic> toJson() => _$WeatherInfoToJson(this);
}

@JsonSerializable()
class MainInfo {
  final double? temp;
  @JsonKey(name: 'feels_like')
  final double? feelsLike;
  @JsonKey(name: 'temp_min')
  final double? tempMin;
  @JsonKey(name: 'temp_max')
  final double? tempMax;
  final int? pressure;
  final int? humidity;

  MainInfo({
    this.temp,
    this.feelsLike,
    this.tempMin,
    this.tempMax,
    this.pressure,
    this.humidity,
  });

  factory MainInfo.fromJson(Map<String, dynamic> json) => _$MainInfoFromJson(json);
  Map<String, dynamic> toJson() => _$MainInfoToJson(this);
}

@JsonSerializable()
class WindInfo {
  final double? speed;
  final int? deg;
  final double? gust;

  WindInfo({this.speed, this.deg, this.gust});

  factory WindInfo.fromJson(Map<String, dynamic> json) => _$WindInfoFromJson(json);
  Map<String, dynamic> toJson() => _$WindInfoToJson(this);
}

@JsonSerializable()
class CloudsInfo {
  final int? all;

  CloudsInfo({this.all});

  factory CloudsInfo.fromJson(Map<String, dynamic> json) => _$CloudsInfoFromJson(json);
  Map<String, dynamic> toJson() => _$CloudsInfoToJson(this);
}

@JsonSerializable()
class SysInfo {
  final String? country;
  final int? sunrise;
  final int? sunset;

  SysInfo({this.country, this.sunrise, this.sunset});

  factory SysInfo.fromJson(Map<String, dynamic> json) => _$SysInfoFromJson(json);
  Map<String, dynamic> toJson() => _$SysInfoToJson(this);
}
