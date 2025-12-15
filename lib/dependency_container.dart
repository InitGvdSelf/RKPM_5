import 'package:rkpm_5/data/datasources/remote/api/dio_client_with_interceptors.dart';
import 'package:rkpm_5/data/datasources/remote/api/weather_api.dart';
import 'package:rkpm_5/data/datasources/remote/api/weather_datasource.dart';
import 'package:rkpm_5/domain/usecases/weather/get_weather_usecase.dart';

class Pr13DependencyContainer {
  // OpenWeatherMap:
  static const String kBaseUrl = 'https://api.openweathermap.org/data/2.5';
  static const String kOpenWeatherApiKey = '8da5f743f266509d96a411100d401bd1';

  late final DioClientWithInterceptors dioClient;
  late final WeatherApi weatherApi;
  late final WeatherDataSource weatherDataSource;
  late final GetWeatherUseCase getWeatherUseCase;

  Pr13DependencyContainer() {
    dioClient = DioClientWithInterceptors(
      baseUrl: kBaseUrl,
      apiKey: kOpenWeatherApiKey,
    );

    // Retrofit sits on top of Dio, so we pass the configured Dio instance.
    weatherApi = WeatherApi(dioClient.dio, baseUrl: kBaseUrl);

    weatherDataSource = WeatherDataSource(weatherApi);
    getWeatherUseCase = GetWeatherUseCase(weatherDataSource);
  }
}
