import 'dart:io';

import 'package:backend/src/core/files/file_generate.dart';
import 'package:backend/src/core/files/file_manager.dart';

class DioGenerator extends FileGenerator {
  @override
  Future<void> generate(
    FileManager fileManager,
    Directory directory, {
    Map<String, dynamic> variables = const {},
  }) async {
    final libConfigDioDioConfiguration = File(
        '${directory.path}${Platform.pathSeparator}lib${Platform.pathSeparator}config${Platform.pathSeparator}dio${Platform.pathSeparator}dio_configuration.dart');
    await libConfigDioDioConfiguration.create(recursive: true);
    await libConfigDioDioConfiguration
        .writeAsString(_libConfigDioDioConfigurationContent);

    final libConfigAppControllerAdviceAppControllerAdvice = File(
        '${directory.path}${Platform.pathSeparator}lib${Platform.pathSeparator}config${Platform.pathSeparator}app_controller_advice.dart');
    await fileManager.insertLineInFile(
      libConfigAppControllerAdviceAppControllerAdvice,
      RegExp(r'AppControllerAdvice\(this._dson\);'),
      _libConfigAppControllerAdviceAppControllerAdviceDioException,
    );
    await fileManager.insertLineInFile(
      position: InsertLinePosition.before,
      libConfigAppControllerAdviceAppControllerAdvice,
      RegExp(r'''^import 'package:vaden/vaden.dart';$'''),
      '''import 'package:dio/dio.dart' hide Response;''',
    );

    final pubspec =
        File('${directory.path}${Platform.pathSeparator}pubspec.yaml');
    await fileManager.insertLineInFile(
      pubspec,
      RegExp(r'^dependencies:$'),
      parseVariables('  dio: {{dio}}', variables),
    );

    final application =
        File('${directory.path}${Platform.pathSeparator}application.yaml');
    await fileManager.insertLineInFile(
      application,
      RegExp(r'^env:$'),
      '  base_url: http://localhost',
    );
  }
}

const _libConfigDioDioConfigurationContent = '''import 'package:dio/dio.dart';
import 'package:vaden/vaden.dart';

@Configuration()
class DioConfiguration {
  @Bean()
  Dio dioApoiaseConfig(ApplicationSettings settings) {
    return Dio(
      BaseOptions(
        baseUrl: settings['env']['base_url'],
        headers: {},
      ),
    );
  }
}
''';

const _libConfigAppControllerAdviceAppControllerAdviceDioException = '''

  @ExceptionHandler(DioException)
  Future<Response> handleDioException(DioException e) async {
    return Response(
      e.response?.statusCode ?? 500,
      body: jsonEncode({
        'message': e.response?.data['message'] ?? 'Internal server error',
      }),
    );
  }''';
