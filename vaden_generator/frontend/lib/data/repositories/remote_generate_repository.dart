import 'package:result_dart/result_dart.dart';

import '../../config/constants.dart';
import '../../domain/entities/metadata.dart';
import '../../domain/entities/project.dart';
import '../services/client_http.dart';
import '../services/url_launcher_service.dart';
import 'generate_repository.dart';

class RemoteGenerateRepository implements GenerateRepository {
  final Constants _constants;
  final ClientHttp _clientHttp;
  final UrlLauncherService _urlLauncherService;

  RemoteGenerateRepository(
    this._constants,
    this._clientHttp,
    this._urlLauncherService,
  );

  @override
  AsyncResult<Unit> createZip(Project project) {
    return _clientHttp //
        .post(
          ClientRequest(
            path: '/v1/generate/start',
            data: project.toMap(),
          ),
        )
        .flatMap(_getProjectLink)
        .flatMap(_urlLauncherService.launch);
  }

  @override
  AsyncResult<Metadata> getMetadata() {
    return _clientHttp //
        .get(ClientRequest(path: '/v1/generate/metadata'))
        .flatMap(_metadataFromResponse);
  }

  Result<String> _getProjectLink(ClientResponse onSuccess) {
    try {
      final String baseUrl = _constants.urlBase;
      final String path = '/resource/uploads/';
      final String fileName = onSuccess.data['url'];
      final String projectName = onSuccess.request.data['projectName'];

      return Success('$baseUrl$path$fileName?name=$projectName.zip');
    } catch (e) {
      return Failure(
        Exception(e.toString()),
      );
    }
  }

  AsyncResult<Metadata> _metadataFromResponse(ClientResponse response) async {
    try {
      final data = Map<String, dynamic>.from(response.data);
      return Success(Metadata.fromMap(data));
    } catch (e) {
      return Failure(
        Exception(e.toString()),
      );
    }
  }
}
