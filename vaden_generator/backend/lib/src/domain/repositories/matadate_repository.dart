import 'package:backend/src/domain/entities/metadata.dart';
import 'package:result_dart/result_dart.dart';

abstract interface class MatadateRepository {
  AsyncResult<Metadata> getMetadata();
}
