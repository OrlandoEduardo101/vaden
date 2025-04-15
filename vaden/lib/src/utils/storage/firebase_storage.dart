part of 'storage.dart';

/// Implementation of the [Storage] interface that uses Firebase Storage for cloud storage.
///
/// The FirebaseStorage class provides file storage capabilities using Firebase Storage,
/// a powerful, simple, and cost-effective cloud storage service built for Google scale.
/// This implementation is suitable for applications that already use other Firebase
/// services or need a simpler alternative to AWS S3.
///
/// Firebase Storage offers several benefits:
/// - Robust operations regardless of network quality
/// - Strong security using Firebase Authentication
/// - Easy integration with other Firebase products
/// - Backed by Google Cloud Storage
/// - Simple client libraries for various platforms
///
/// Example usage:
/// ```dart
/// final storage = FirebaseStorage(
///   projectId: 'my-firebase-project',
///   apiKey: 'api-key',
/// );
///
/// // Upload a file
/// final filePath = await storage.upload('image.jpg', imageBytes);
/// ```
///
/// Configuration in application settings:
/// ```yaml
/// storage:
///   provider: 'firebase'
///   provider:
///     firebase:
///       projectId: 'my-firebase-project'
///       apiKey: 'api-key'
/// ```
///
/// Note: This implementation requires the Firebase SDK for Dart to be properly installed
/// and configured in your project.
class FirebaseStorage extends Storage {
  /// The Firebase project ID where the storage bucket is located.
  ///
  /// This ID is used to identify the Firebase project and connect to the correct storage bucket.
  final String projectId;

  /// The Firebase API key used for authentication.
  ///
  /// This key is used to authenticate requests to the Firebase Storage service.
  final String apiKey;

  /// Creates a new FirebaseStorage instance with the specified Firebase credentials.
  ///
  /// Parameters:
  /// - [projectId]: The Firebase project ID where the storage bucket is located.
  /// - [apiKey]: The Firebase API key used for authentication.
  FirebaseStorage({
    required this.projectId,
    required this.apiKey,
  });

  /// Deletes a file from Firebase Storage.
  ///
  /// This method removes a file from Firebase Storage based on its path. When implemented,
  /// it will handle Firebase authentication and file deletion operations.
  ///
  /// Parameters:
  /// - [filePath]: The path of the file to delete within Firebase Storage.
  ///   This should match the path used when uploading the file.
  ///
  /// Returns:
  /// - A Future that completes when the file has been deleted.
  ///
  /// Throws:
  /// - [Exception]: If the file does not exist at the specified path.
  /// - [Exception]: If there are permission issues preventing deletion.
  /// - [UnimplementedError]: This method is not yet implemented.
  ///
  /// Example usage (when implemented):
  /// ```dart
  /// final storage = FirebaseStorage(
  ///   projectId: 'my-firebase-project',
  ///   apiKey: 'api-key',
  /// );
  ///
  /// try {
  ///   // Delete a file from Firebase Storage
  ///   await storage.delete('user/123/old-profile.jpg');
  ///   print('File deleted successfully');
  /// } catch (e) {
  ///   print('Error deleting file: $e');
  /// }
  /// ```
  ///
  /// TODO: Implement this method using the Firebase SDK for Dart.
  @override
  Future<void> delete(String filePath) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  /// Downloads a file from Firebase Storage.
  ///
  /// This method retrieves a file from Firebase Storage based on its path. When implemented,
  /// it will handle Firebase authentication and file download operations.
  ///
  /// Parameters:
  /// - [filePath]: The path of the file to download within Firebase Storage.
  ///   This should match the path used when uploading the file.
  ///
  /// Returns:
  /// - A Future that resolves to the contents of the file as a byte array.
  ///   This can be used to display the file or save it locally.
  ///
  /// Throws:
  /// - [Exception]: If the file does not exist at the specified path.
  /// - [Exception]: If there are permission issues or network problems.
  /// - [UnimplementedError]: This method is not yet implemented.
  ///
  /// Example usage (when implemented):
  /// ```dart
  /// final storage = FirebaseStorage(
  ///   projectId: 'my-firebase-project',
  ///   apiKey: 'api-key',
  /// );
  ///
  /// try {
  ///   // Download a file from Firebase Storage
  ///   final imageBytes = await storage.download('user/123/profile.jpg');
  ///
  ///   // Save the downloaded file locally
  ///   await File('downloaded_profile.jpg').writeAsBytes(imageBytes);
  ///   print('File downloaded successfully');
  /// } catch (e) {
  ///   print('Error downloading file: $e');
  /// }
  /// ```
  ///
  /// TODO: Implement this method using the Firebase SDK for Dart.
  @override
  Future<List<int>> download(String filePath) {
    // TODO: implement download
    throw UnimplementedError();
  }

  /// Lists all files in a folder in Firebase Storage.
  ///
  /// This method retrieves a list of file paths for all files in the specified folder
  /// within Firebase Storage. When implemented, it will handle pagination for large folders
  /// and proper error handling for access issues.
  ///
  /// Parameters:
  /// - [folder]: The path of the folder to list files from within Firebase Storage.
  ///   For example, 'images/' or 'user/123/'.
  ///
  /// Returns:
  /// - A Future that resolves to a list of file paths for all files in the folder.
  ///   These paths can be used with the download method to retrieve the files.
  ///
  /// Throws:
  /// - [Exception]: If the folder does not exist or cannot be accessed.
  /// - [Exception]: If there are permission issues or network problems.
  /// - [UnimplementedError]: This method is not yet implemented.
  ///
  /// Example usage (when implemented):
  /// ```dart
  /// final storage = FirebaseStorage(
  ///   projectId: 'my-firebase-project',
  ///   apiKey: 'api-key',
  /// );
  ///
  /// try {
  ///   // List all files in a user's folder
  ///   final userFiles = await storage.listFiles('user/123/');
  ///
  ///   print('Found ${userFiles.length} files:');
  ///   for (final filePath in userFiles) {
  ///     print(' - $filePath');
  ///
  ///     // You can download each file if needed
  ///     // final fileContent = await storage.download(filePath);
  ///   }
  /// } catch (e) {
  ///   print('Error listing files: $e');
  /// }
  /// ```
  ///
  /// TODO: Implement this method using the Firebase SDK for Dart.
  @override
  Future<List<String>> listFiles(String folder) {
    // TODO: implement listFiles
    throw UnimplementedError();
  }

  /// Uploads a file to Firebase Storage.
  ///
  /// This method uploads a file to Firebase Storage at the specified path. When implemented,
  /// it will handle Firebase authentication and file upload operations.
  ///
  /// Parameters:
  /// - [filePath]: The path where the file should be stored within Firebase Storage.
  ///   For example, 'images/profile.jpg' will store the file in the 'images' folder.
  /// - [bytes]: The contents of the file as a byte array.
  ///
  /// Returns:
  /// - A Future that resolves to the path of the uploaded file within Firebase Storage.
  ///   This path can be used to download or reference the file later.
  ///
  /// Throws:
  /// - [Exception]: If the upload fails due to network issues.
  /// - [Exception]: If the file cannot be stored due to permission issues.
  /// - [UnimplementedError]: This method is not yet implemented.
  ///
  /// Example usage (when implemented):
  /// ```dart
  /// final storage = FirebaseStorage(
  ///   projectId: 'my-firebase-project',
  ///   apiKey: 'api-key',
  /// );
  ///
  /// // Read a local file
  /// final imageBytes = await File('local_image.jpg').readAsBytes();
  ///
  /// // Upload the file to Firebase Storage
  /// final storagePath = await storage.upload('user/123/profile.jpg', imageBytes);
  /// print('File uploaded to: $storagePath');
  ///
  /// // The file is now accessible via Firebase Storage
  /// ```
  ///
  /// TODO: Implement this method using the Firebase SDK for Dart.
  @override
  Future<String> upload(String filePath, List<int> bytes) async {
    final fileBytes = bytes;

    final uri = Uri.parse(
      'https://storage.googleapis.com/upload/storage/v1/b/$projectId/o?uploadType=media&name=$filePath',
    );

    final response = await dio.Dio().post(
      uri.toString(),
      options: dio.Options(headers: {
        'Authorization': 'Bearer $apiKey',
        'Content-Type': 'application/octet-stream',
      }),
      data: fileBytes,
    );

    if (response.statusCode == 200) {
      log('Upload bem-sucedido!');
      log(response.data);
      return response.data['name'];
    } else {
      log('Erro no upload: ${response.statusCode}');
      log(response.data);
      return '';
    }
  }
}
