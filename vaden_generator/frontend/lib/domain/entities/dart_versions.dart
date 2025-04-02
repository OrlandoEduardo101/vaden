import 'dart:convert';

class DartVersion {
  final String id;
  final String name;

  DartVersion({
    required this.id,
    required this.name,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }

  factory DartVersion.fromMap(Map<String, dynamic> map) {
    return DartVersion(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory DartVersion.fromJson(String source) => DartVersion.fromMap(json.decode(source));
}
