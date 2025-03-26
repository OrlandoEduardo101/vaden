import 'dart:io';

import 'package:backend/src/core/files/file_generate.dart';
import 'package:backend/src/core/files/file_manager.dart';

class PostgresGenerator extends FileGenerator {
  @override
  Future<void> generate(
    FileManager fileManager,
    Directory directory, {
    Map<String, dynamic> variables = const {},
  }) async {
    final libConfigPostgresPostgresConfiguration = File(
        '${directory.path}${Platform.pathSeparator}lib${Platform.pathSeparator}config${Platform.pathSeparator}postgres${Platform.pathSeparator}postgres_configuration.dart');
    await libConfigPostgresPostgresConfiguration.create(recursive: true);
    await libConfigPostgresPostgresConfiguration
        .writeAsString(_libConfigPostgresPostgresConfigurationContent);

    final pubspec =
        File('${directory.path}${Platform.pathSeparator}pubspec.yaml');
    await fileManager.insertLineInFile(
      pubspec,
      RegExp(r'^dependencies:$'),
      parseVariables('  postgres: {{postgres}}', variables),
    );

    final application =
        File('${directory.path}${Platform.pathSeparator}application.yaml');
    await fileManager.insertLineInFile(
      position: InsertLinePosition.before,
      application,
      RegExp(r'^server:$'),
      'postgres:',
    );
    await fileManager.insertLineInFile(
      application,
      RegExp(r'^postgres:$'),
      '  ssl: disable',
    );
    await fileManager.insertLineInFile(
      application,
      RegExp(r'^postgres:$'),
      '  password: password',
    );
    await fileManager.insertLineInFile(
      application,
      RegExp(r'^postgres:$'),
      '  username: username',
    );
    await fileManager.insertLineInFile(
      application,
      RegExp(r'^postgres:$'),
      '  port: 5432',
    );
    await fileManager.insertLineInFile(
      application,
      RegExp(r'^postgres:$'),
      '  database: postgres',
    );
    await fileManager.insertLineInFile(
      application,
      RegExp(r'^postgres:$'),
      '  host: 0.0.0.0',
    );
  }
}

const _libConfigPostgresPostgresConfigurationContent =
    '''import 'package:postgres/postgres.dart';
import 'package:vaden/vaden.dart';

@Configuration()
class PostgresConfiguration {
  @Bean()
  Future<Connection> connection(ApplicationSettings settings) {
    SslMode sslAdapter(String? ssl) {
      return switch (ssl) {
        'disable' => SslMode.disable,
        'require' => SslMode.require,
        'verifyFull' => SslMode.verifyFull,
        _ => SslMode.disable,
      };
    }

    return Connection.open(
      Endpoint(
        host: settings['postgres']['host'],
        database: settings['postgres']['database'],
        port: int.parse(settings['postgres']['port']),
        username: settings['postgres']['username'],
        password: settings['postgres']['password'],
      ),
      settings:
          ConnectionSettings(sslMode: sslAdapter(settings['postgres']['ssl'])),
    );
  }
}
''';
