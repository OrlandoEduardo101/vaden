import 'dart:convert';

class Dependency {
  final String name;
  final String description;
  final String key;
  final String tag;
  final List<String> requirements;

  Dependency({
    required this.name,
    required this.description,
    required this.key,
    required this.tag,
    this.requirements = const [],
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'key': key,
      'tag': tag,
      'requirements': requirements,
    };
  }

  factory Dependency.fromMap(Map<String, dynamic> map) {
    return Dependency(
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      key: map['key'] ?? '',
      tag: map['tag'] ?? '',
      requirements: List<String>.from(map['requirements']),
    );
  }

  String toJson() => json.encode(toMap());

  factory Dependency.fromJson(String source) => Dependency.fromMap(json.decode(source));
}
