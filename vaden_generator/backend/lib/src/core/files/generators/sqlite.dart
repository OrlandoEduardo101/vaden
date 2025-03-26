import 'dart:io';

import 'package:backend/src/core/files/file_generate.dart';
import 'package:backend/src/core/files/file_manager.dart';

/// Generator for SQLite database integration.
/// 
/// This generator adds SQLite dependencies, configuration files, and settings
/// to a Vaden project.
class SqliteGenerator extends FileGenerator {
  @override
  Future<void> generate(
    FileManager fileManager,
    Directory directory, {
    Map<String, dynamic> variables = const {},
  }) async {
    // Create SQLite configuration file
    final libConfigSqliteSqliteConfiguration = File(
        '${directory.path}${Platform.pathSeparator}lib${Platform.pathSeparator}config${Platform.pathSeparator}sqlite${Platform.pathSeparator}sqlite_configuration.dart');
    await libConfigSqliteSqliteConfiguration.create(recursive: true);
    await libConfigSqliteSqliteConfiguration
        .writeAsString(_libConfigSqliteSqliteConfigurationContent);

    // Add SQLite dependency to pubspec.yaml
    final pubspec =
        File('${directory.path}${Platform.pathSeparator}pubspec.yaml');
    await fileManager.insertLineInFile(
      pubspec,
      RegExp(r'^dependencies:$'),
      parseVariables('  sqlite3: {{sqlite3}}', variables),
    );

    // Add SQLite configuration to application.yaml
    final application =
        File('${directory.path}${Platform.pathSeparator}application.yaml');
    await fileManager.insertLineInFile(
      position: InsertLinePosition.before,
      application,
      RegExp(r'^server:$'),
      'sqlite:',
    );
    await fileManager.insertLineInFile(
      application,
      RegExp(r'^sqlite:$'),
      '  database_path: database.db',
    );
    await fileManager.insertLineInFile(
      application,
      RegExp(r'^sqlite:$'),
      '  create_if_missing: true',
    );
  }
}

const _libConfigSqliteSqliteConfigurationContent =
    '''import 'dart:io';
import 'package:sqlite3/sqlite3.dart';
import 'package:vaden/vaden.dart';

@Configuration()
class SqliteConfiguration {
  @Bean()
  Database sqliteDatabase(ApplicationSettings settings) {
    final databasePath = settings['sqlite']['database_path'];
    final createIfMissing = settings['sqlite']['create_if_missing'] == 'true';
    
    // Create database directory if it doesn't exist
    final dbFile = File(databasePath);
    if (!dbFile.existsSync() && createIfMissing) {
      dbFile.parent.createSync(recursive: true);
    }
    
    // Open the database
    return sqlite3.open(databasePath);
  }
  
  void closeDatabase(Database database) {
    database.dispose();
  }
}
''';
