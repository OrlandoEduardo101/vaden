import 'package:backend/src/domain/entities/metadata.dart';
import 'package:backend/src/domain/repositories/matadate_repository.dart';
import 'package:result_dart/result_dart.dart';
import 'package:vaden/vaden.dart';

@Component()
class GetMetadata {
  final MatadateRepository _matadateRepository;

  GetMetadata(this._matadateRepository);

  AsyncResult<Metadata> call() async {
    return await _matadateRepository.getMetadata();
  }
}
