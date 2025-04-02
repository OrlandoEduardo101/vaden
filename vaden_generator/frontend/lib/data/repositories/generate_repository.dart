import '../../domain/entities/metadata.dart';
import '../../domain/entities/project.dart';
import 'package:result_dart/result_dart.dart';

abstract interface class GenerateRepository {
  AsyncResult<Metadata> getMetadata();

  AsyncResult<Unit> createZip(Project project);
}
