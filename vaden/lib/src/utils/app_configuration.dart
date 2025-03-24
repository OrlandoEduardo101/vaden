import 'dart:io';

import 'package:yaml/yaml.dart';

/// A class for loading and accessing application configuration from YAML files.
///
/// The ApplicationSettings class provides a simple way to load configuration settings
/// from a YAML file and access them using a map-like syntax. This is useful for
/// managing environment-specific configuration such as database connection strings,
/// API keys, feature flags, and other application settings.
///
/// The configuration is loaded from a YAML file at the specified path and can be
/// accessed using the subscript operator (`[]`).
///
/// Example YAML configuration file (config.yaml):
/// ```yaml
/// app:
///   name: My Vaden App
///   version: 1.0.0
/// server:
///   host: localhost
///   port: 8080
/// database:
///   url: postgres://user:password@localhost:5432/mydb
///   poolSize: 10
/// features:
///   enableLogging: true
///   enableCaching: false
/// ```
///
/// Example usage:
/// ```dart
/// void main() {
///   final config = ApplicationSettings.load('config.yaml');
///   
///   final appName = config['app']['name'];
///   final serverPort = config['server']['port'];
///   final dbUrl = config['database']['url'];
///   final enableLogging = config['features']['enableLogging'];
///   
///   print('Starting $appName on port $serverPort');
///   
///   // Use the configuration values to set up the application
/// }
/// ```
class ApplicationSettings {
  /// The internal map containing the configuration values loaded from the YAML file.
  final Map _yamlMap;

  /// Private constructor that takes a map of configuration values.
  ///
  /// This constructor is private to enforce the use of the [load] factory method
  /// for creating instances of ApplicationSettings.
  ApplicationSettings._(this._yamlMap);

  /// Loads configuration settings from a YAML file at the specified path.
  ///
  /// This factory method reads the YAML file, parses its contents, and returns
  /// an ApplicationSettings instance that provides access to the configuration values.
  ///
  /// Parameters:
  /// - [path]: The path to the YAML configuration file.
  ///
  /// Returns:
  /// - An ApplicationSettings instance containing the configuration values.
  ///
  /// Throws:
  /// - [FileSystemException]: If the file cannot be read.
  /// - [YamlException]: If the YAML content is invalid.
  static ApplicationSettings load(String path) {
    final file = File(path);
    final content = file.readAsStringSync();
    final yamlMap = loadYaml(content) as YamlMap;

    final config = ApplicationSettings._(yamlMap);
    return config;
  }

  /// Accesses a configuration value by key.
  ///
  /// This operator allows accessing configuration values using a map-like syntax.
  /// The returned value can be a primitive type (String, num, bool), a nested map,
  /// or a list, depending on the structure of the YAML file.
  ///
  /// Parameters:
  /// - [key]: The key of the configuration value to access.
  ///
  /// Returns:
  /// - The configuration value associated with the key, or null if the key does not exist.
  dynamic operator [](String key) {
    return _yamlMap[key];
  }
}
