import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:rkpm_5/core/models/weather.dart';
import 'package:rkpm_5/data/datasources/remote/api/exceptions/network_exceptions.dart';
import 'package:rkpm_5/dependency_container.dart';

class WeatherScreen extends StatefulWidget {
  final Pr13DependencyContainer di;

  const WeatherScreen({super.key, required this.di});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final _controller = TextEditingController(text: 'Stockholm');
  bool _loading = false;
  Weather? _weather;
  String? _error;

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
      _weather = null;
    });

    try {
      final w = await widget.di.getWeatherUseCase.execute(_controller.text);
      setState(() => _weather = w);
    } on DioException catch (_) {
      setState(() => _error = 'Unexpected Dio error');
    } on ArgumentError catch (e) {
      setState(() => _error = e.message as String? ?? e.toString());
    } catch (e) {
      // If error mapping interceptor worked, `e` will often be DioException with `.error` of NetworkException,
      // but in UI we handle both cases.
      if (e is NetworkException) {
        setState(() => _error = e.message);
      } else {
        setState(() => _error = e.toString());
      }
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildResult() {
    if (_loading) return const Center(child: CircularProgressIndicator());
    if (_error != null) return Text('Error: $_error', style: const TextStyle(color: Colors.red));
    if (_weather == null) return const Text('Enter a city and press "Get weather".');

    final w = _weather!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('${w.city}${w.country != null ? ', ${w.country}' : ''}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Text('Temp: ${w.temperatureFormatted} (feels like ${w.feelsLikeFormatted})'),
        if (w.description != null) Text('Description: ${w.description}'),
        if (w.humidity != null) Text('Humidity: ${w.humidity}%'),
        if (w.windSpeed != null) Text('Wind: ${w.windSpeed} m/s'),
        const SizedBox(height: 8),
        Text('Daytime: ${w.isDaytime ? 'yes' : 'no'}'),
        Text('Updated: ${w.updatedAt}'),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('PR13 — Retrofit Weather Demo')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'City',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _loading ? null : _load,
                child: const Text('Get weather'),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(child: SingleChildScrollView(child: _buildResult())),
          ],
        ),
      ),
    );
  }
}
