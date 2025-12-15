import 'package:rkpm_5/core/errors/failure.dart';
import 'package:rkpm_5/core/utils/either.dart';
import 'package:rkpm_5/data/datasources/remote/dadata/dadata_datasource.dart';
import 'package:rkpm_5/data/datasources/remote/dadata/dto/dadata_suggest_dto.dart';

class SuggestAddressUseCase {
  final DadataDataSource datasource;

  SuggestAddressUseCase(this.datasource);

  Future<Either<Failure, List<DadataSuggestionDto>>> call(String query) async {
    try {
      final suggestions = await datasource.suggestAddress(query);
      return Either.right(suggestions);
    } catch (e) {
      return Either.left(NetworkFailure(e.toString()));
    }
  }
}

