/// API configuration constants for remote data sources.
class ApiConfig {
  /// DaData API token from environment variable, or default token if not provided.
  /// Can be overridden via --dart-define=DADATA_TOKEN=...
  static const String _dadataTokenEnv = String.fromEnvironment('DADATA_TOKEN');
  static const String _dadataTokenDefault = '28a725ceea9a2196367c6944efda728cd8ef6bd5';
  static String get dadataToken => _dadataTokenEnv.isNotEmpty ? _dadataTokenEnv : _dadataTokenDefault;

  /// DaData base URL for address suggestions and geocoding.
  static const String dadataBaseUrl = 'https://suggestions.dadata.ru/suggestions/api/4_1/rs';

  /// openFDA base URL for drug information.
  static const String openFdaBaseUrl = 'https://api.fda.gov';

  /// Overpass API base URL for OpenStreetMap queries.
  static const String overpassBaseUrl = 'https://overpass-api.de/api';

  /// Validates that DaData token is set.
  /// Throws if token is empty (should not happen with default token).
  static void validateDadataToken() {
    if (dadataToken.isEmpty) {
      throw Exception(
        'DaData token is not set. Run with --dart-define=DADATA_TOKEN=YOUR_TOKEN',
      );
    }
  }
}

