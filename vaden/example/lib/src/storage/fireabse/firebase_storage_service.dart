import 'dart:developer';

import 'package:vaden/vaden.dart';

@Service()
class FirebaseStorageService {
  final Storage _storage;

  FirebaseStorageService(this._storage);

  Future<String> upload(String filePath, List<int> bytes) async {
    try {
      final ref = await _storage.upload(filePath, bytes);
      log(ref);
      return ref;
    } catch (e) {
      log('Error uploading file: $e');
      return '';
    }
  }
}
