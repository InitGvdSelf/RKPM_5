import 'package:dio/dio.dart';
import 'package:rkpm_5/data/datasources/remote/api/dio_client_with_interceptors.dart';
import 'package:rkpm_5/data/datasources/remote/openfda/dto/openfda_drug_dto.dart';

/// Remote data source for openFDA API (drug information).
class OpenFdaDataSource {
  final DioClientWithInterceptors client;

  OpenFdaDataSource(this.client);

  /// Search drug information by medicine name.
  /// First tries brand_name, then generic_name if no results.
  Future<OpenFdaDrugDto?> searchDrug(String name) async {
    try {
      // Try brand_name first
      var response = await client.get(
        '/drug/label.json',
        queryParameters: {
          'search': 'openfda.brand_name:"$name"',
          'limit': 1,
        },
      );

      var dto = OpenFdaDrugDto.fromJson(response.data as Map<String, dynamic>);

      // If no brand name found, try generic_name
      if (dto.brandName == null && dto.genericName == null) {
        response = await client.get(
          '/drug/label.json',
          queryParameters: {
            'search': 'openfda.generic_name:"$name"',
            'limit': 1,
          },
        );

        dto = OpenFdaDrugDto.fromJson(response.data as Map<String, dynamic>);
      }

      // Return null if still no data
      if (dto.brandName == null &&
          dto.genericName == null &&
          dto.indicationsAndUsage == null &&
          dto.warnings == null) {
        return null;
      }

      return dto;
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        return null;
      }
      throw Exception('Failed to search drug: ${e.message}');
    }
  }
}

