import 'package:backend/src/domain/entities/dart_version.dart';
import 'package:backend/src/domain/entities/dependency.dart';
import 'package:vaden/vaden.dart';

@DTO()
class Metadata {
  final List<Dependency> dependencies;
  final DartVersion defaultDartVersion;
  final List<DartVersion> dartVersions;

  Metadata({
    required this.dependencies,
    required this.defaultDartVersion,
    required this.dartVersions,
  });
}
