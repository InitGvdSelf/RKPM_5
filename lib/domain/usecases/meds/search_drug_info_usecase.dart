import 'package:rkpm_5/core/errors/failure.dart';
import 'package:rkpm_5/core/models/drug_info_model.dart';
import 'package:rkpm_5/core/utils/either.dart';
import 'package:rkpm_5/data/datasources/remote/openfda/mappers/openfda_mapper.dart';
import 'package:rkpm_5/data/datasources/remote/openfda/openfda_datasource.dart';

class SearchDrugInfoUseCase {
  final OpenFdaDataSource datasource;

  SearchDrugInfoUseCase(this.datasource);

  Future<Either<Failure, DrugInfo?>> call(String name) async {
    try {
      final dto = await datasource.searchDrug(name);
      final drugInfo = OpenFdaMapper.toDomain(dto);
      return Either.right(drugInfo);
    } catch (e) {
      return Either.left(NetworkFailure(e.toString()));
    }
  }
}

