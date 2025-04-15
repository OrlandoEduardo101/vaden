import 'package:vaden/vaden.dart';

import 'fireabse/firebase_storage_service.dart';

@Controller('/storage')
class StorageController {
  final FirebaseStorageService _firebaseStorageService;

  StorageController(this._firebaseStorageService);

  @Get('/ping')
  Future<Response> ping() async {
    return Response.ok('Pong');
  }

  @Post('/upload-firebase')
  Future<Response> uploadFileToFirebase(Request request) async {
    final filePath = request.url.queryParameters['filePath'];
    if (filePath == null || filePath.isEmpty) {
      return Response.badRequest(body: 'File path is required');
    }
    if (request.formData() case var form?) {
      final parameters = <String, dynamic>{
        await for (final formData in form.formData) formData.name: await formData.part.readBytes(),
      };

      final response = await _firebaseStorageService.upload(filePath, parameters['file']!);
      return Response.ok(response);
    } else {
      return Response.badRequest(body: 'Invalid form data');
    }
  }
}
