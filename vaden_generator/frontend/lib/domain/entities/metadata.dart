import 'dart:convert';

import 'dart_versions.dart';
import 'dependency.dart';

class Metadata {
  final List<Dependency> dependencies;
  final DartVersion defaultDartVersion;
  final List<DartVersion> dartVersions;

  Metadata({
    required this.dependencies,
    required this.defaultDartVersion,
    required this.dartVersions,
  });

  Map<String, dynamic> toMap() {
    return {
      'dependencies': dependencies.map((x) => x.toMap()).toList(),
      'defaultDartVersion': defaultDartVersion.toMap(),
      'dartVersions': dartVersions.map((x) => x.toMap()).toList(),
    };
  }

  factory Metadata.fromMap(Map<String, dynamic> map) {
    return Metadata(
      dependencies: List<Dependency>.from(map['dependencies']?.map((x) => Dependency.fromMap(x))),
      defaultDartVersion: DartVersion.fromMap(map['defaultDartVersion']),
      dartVersions: List<DartVersion>.from(map['dartVersions']?.map((x) => DartVersion.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory Metadata.fromJson(String source) => Metadata.fromMap(json.decode(source));
}
