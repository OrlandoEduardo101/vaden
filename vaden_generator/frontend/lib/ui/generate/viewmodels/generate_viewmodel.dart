import 'package:flutter/material.dart';
import 'package:result_command/result_command.dart';
import 'package:result_dart/result_dart.dart';

import '../../../data/repositories/generate_repository.dart';
import '../../../domain/entities/dart_versions.dart';
import '../../../domain/entities/dependency.dart';
import '../../../domain/entities/metadata.dart';
import '../../../domain/entities/project.dart';

class GenerateViewmodel extends ChangeNotifier {
  GenerateViewmodel(this._generateRepository);
  final GenerateRepository _generateRepository;

  late final fetchMedatadaCommand = Command0<Metadata>(_fetchMetadata);
  late final createProjectCommand = Command1(_createProject);

  List<DartVersion> _dartVersions = [];
  List<DartVersion> get dartVersions => _dartVersions;
  DartVersion _defaultDartVersion = DartVersion(id: '', name: '');
  DartVersion get defaultDartVersion => _defaultDartVersion;
  List<Dependency> _dependencies = [];
  List<Dependency> get dependencies => _dependencies;

  final _formKey = GlobalKey<FormState>();
  GlobalKey<FormState> get formKey => _formKey;

  void _setDependencies(Metadata metadata) {
    _dartVersions = metadata.dartVersions;
    _defaultDartVersion = metadata.defaultDartVersion;
    _dependencies = metadata.dependencies;
    notifyListeners();
  }

  final List<Dependency> _projectDependencies = [];
  List<Dependency> get projectDependencies => _projectDependencies;

  AsyncResult<Metadata> _fetchMetadata() {
    return _generateRepository //
        .getMetadata()
        .onSuccess(_setDependencies);
  }

  AsyncResult<Unit> _createProject(Project project) {
    return _generateRepository //
        .createZip(project);
  }
}
