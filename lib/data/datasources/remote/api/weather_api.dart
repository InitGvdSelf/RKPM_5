import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../dto/weather_dto.dart';

part 'weather_api.g.dart';

@RestApi()
abstract class WeatherApi {
  factory WeatherApi(Dio dio, {String baseUrl}) = _WeatherApi;

  @GET('/weather')
  Future<WeatherDTO> getCurrentWeather(
      @Query('q') String city, {
        @Query('units') String units = 'metric',
        @Query('lang') String lang = 'en',
      });

  @GET('/forecast')
  Future<List<WeatherDTO>> getFiveDayForecast(
      @Query('q') String city, {
        @Query('units') String units = 'metric',
        @Query('lang') String lang = 'en',
      });
}