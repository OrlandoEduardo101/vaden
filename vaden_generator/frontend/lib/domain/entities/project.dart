import 'dart:convert';

import 'package:flutter/material.dart';

class Project extends ChangeNotifier {
  String name;
  String description;
  String dartVersion;
  List<String> dependenciesKeys;

  Project._(
    this.name,
    this.description,
    this.dartVersion,
    this.dependenciesKeys,
  );

  factory Project() {
    return Project._('', '', '', []);
  }

  void setName(String value) {
    name = value;
    notifyListeners();
  }

  void setDescription(String value) {
    description = value;
    notifyListeners();
  }

  void setDartVersion(String value) {
    dartVersion = value;
    notifyListeners();
  }

  void setDependencies(List<String> value) => dependenciesKeys = value;

  Map<String, dynamic> toMap() {
    return {
      'projectName': name,
      'projectDescription': description,
      'dartVersion': dartVersion,
      'dependenciesKeys': dependenciesKeys,
    };
  }

  factory Project.fromMap(Map<String, dynamic> map) {
    return Project._(
      map['projectName'] ?? '',
      map['projectDescription'] ?? '',
      map['dartVersion'] ?? '',
      List<String>.from(map['dependenciesKeys']),
    );
  }

  String toJson() => json.encode(toMap());

  factory Project.fromJson(String source) => Project.fromMap(json.decode(source));
}
