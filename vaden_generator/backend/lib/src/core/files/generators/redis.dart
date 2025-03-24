import 'dart:io';

import 'package:backend/src/core/files/file_generate.dart';
import 'package:backend/src/core/files/file_manager.dart';

class RedisGenerator extends FileGenerator {
  @override
  Future<void> generate(
    FileManager fileManager,
    Directory directory, {
    Map<String, dynamic> variables = const {},
  }) async {
    final libConfigRedisRedisConfiguration = File(
        '${directory.path}${Platform.pathSeparator}lib${Platform.pathSeparator}config${Platform.pathSeparator}redis${Platform.pathSeparator}redis_configuration.dart');
    await libConfigRedisRedisConfiguration.create(recursive: true);
    await libConfigRedisRedisConfiguration
        .writeAsString(_libConfigRedisRedisConfigurationContent);

    final pubspec =
        File('${directory.path}${Platform.pathSeparator}pubspec.yaml');
    await fileManager.insertLineInFile(
      pubspec,
      RegExp(r'^dependencies:$'),
      parseVariables('  redis: {{redis}}', variables),
    );

    final application =
        File('${directory.path}${Platform.pathSeparator}application.yaml');
    await fileManager.insertLineInFile(
      position: InsertLinePosition.before,
      application,
      RegExp(r'^server:$'),
      'redis:',
    );
    await fileManager.insertLineInFile(
      application,
      RegExp(r'^redis:$'),
      '  host: localhost',
    );
    await fileManager.insertLineInFile(
      application,
      RegExp(r'^redis:$'),
      '  port: 6379',
    );
  }
}

const _libConfigRedisRedisConfigurationContent =
    '''import 'package:redis/redis.dart';
import 'package:vaden/vaden.dart';

@Configuration()
class RedisConfiguration {
  @Bean()
  Future<Command> redisCommand(ApplicationSettings settings) {
    final host = settings['redis']['host'];
    final port = settings['redis']['port'];
    final connection = RedisConnection();
    return connection.connect(host, port);
  }
}
''';
