import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart' as dio;
import 'package:mime/mime.dart';
import 'package:uuid/uuid.dart';
import 'package:vaden/vaden.dart';

part 'aws_s3_storage.dart';
part 'firebase_storage.dart';
part 'local_storage.dart';

/// Abstract class defining the interface for file storage in the Vaden framework.
///
/// The Storage class provides a unified interface for file operations (upload, download,
/// delete, list) across different storage providers such as local file system, AWS S3,
/// or Firebase Storage. This abstraction allows applications to switch between storage
/// providers without changing the application code that interacts with storage.
///
/// Implementations of this class handle the specific details of interacting with each
/// storage provider, while exposing a consistent API to the application.
///
/// Example usage:
/// ```dart
/// // Create a storage service based on application settings
/// final storage = Storage.createStorageService(appSettings);
///
/// // Upload a file
/// final filePath = await storage.upload('images/profile.jpg', imageBytes);
///
/// // Download a file
/// final fileBytes = await storage.download(filePath);
///
/// // List files in a folder
/// final files = await storage.listFiles('images');
///
/// // Delete a file
/// await storage.delete(filePath);
/// ```
abstract class Storage {
  /// Uploads a file to the storage provider.
  ///
  /// This method takes a file path and the file contents as a byte array, and uploads
  /// the file to the storage provider. The file path is used to determine the location
  /// and name of the file in the storage system.
  ///
  /// Parameters:
  /// - [filePath]: The path where the file should be stored, including the file name.
  /// - [bytes]: The contents of the file as a byte array.
  ///
  /// Returns:
  /// - A Future that resolves to the path of the uploaded file, which can be used
  ///   to download or reference the file later.
  Future<String> upload(String filePath, List<int> bytes);

  /// Downloads a file from the storage provider.
  ///
  /// This method retrieves a file from the storage provider based on its path.
  ///
  /// Parameters:
  /// - [filePath]: The path of the file to download.
  ///
  /// Returns:
  /// - A Future that resolves to the contents of the file as a byte array.
  Future<List<int>> download(String filePath);

  /// Deletes a file from the storage provider.
  ///
  /// This method removes a file from the storage provider based on its path.
  ///
  /// Parameters:
  /// - [filePath]: The path of the file to delete.
  ///
  /// Returns:
  /// - A Future that completes when the file has been deleted.
  Future<void> delete(String filePath);

  /// Lists all files in a folder in the storage provider.
  ///
  /// This method retrieves a list of file paths for all files in the specified folder.
  ///
  /// Parameters:
  /// - [folder]: The path of the folder to list files from.
  ///
  /// Returns:
  /// - A Future that resolves to a list of file paths for all files in the folder.
  Future<List<String>> listFiles(String folder);

  /// Creates a storage service based on the application settings.
  ///
  /// This factory method examines the application settings to determine which storage
  /// provider to use, and creates an appropriate implementation of the Storage interface.
  /// The method supports three storage providers: AWS S3, Firebase Storage, and local
  /// file system storage. If the specified provider is not recognized or no provider
  /// is specified, local storage is used as the default.
  ///
  /// The configuration for each storage provider is read from the application settings,
  /// which should have a structure similar to the following:
  ///
  /// ```yaml
  /// storage:
  ///   provider: 's3'  # or 'firebase' or 'local'
  ///   provider:
  ///     s3:  # Only needed if provider is 's3'
  ///       bucket: 'my-bucket'
  ///       region: 'us-east-1'
  ///       accessKey: 'AKIAIOSFODNN7EXAMPLE'
  ///       secretKey: 'wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY'
  ///     firebase:  # Only needed if provider is 'firebase'
  ///       projectId: 'my-project-id'
  ///       apiKey: 'api-key'
  ///   local:  # Only needed if provider is 'local' or not specified
  ///     folder: 'uploads'
  /// ```
  ///
  /// Parameters:
  /// - [settings]: The application settings containing the storage configuration.
  ///
  /// Returns:
  /// - An implementation of the Storage interface for the specified provider.
  static Storage createStorageService(ApplicationSettings settings) {
    switch (settings['storage']['provider']) {
      case 's3':
        return AwsS3Storage(
          bucket: settings['storage']['s3']['bucket'],
          region: settings['storage']['s3']['region'],
          accessKey: settings['storage']['s3']['accessKey'],
          secretKey: settings['storage']['s3']['secretKey'],
        );
      case 'firebase':
        return FirebaseStorage(
          projectId: settings['storage']['firebase']['projectId'],
          apiKey: settings['storage']['firebase']['apiKey'],
        );
      case 'local':
      default:
        return LocalStorage(settings['storage']['local']['folder']);
    }
  }

  /// Determines the MIME type of a file based on its path.
  ///
  /// This utility method uses the file extension to determine the MIME type of a file.
  /// If the MIME type cannot be determined from the file extension, it defaults to
  /// 'application/octet-stream', which is a generic binary file type.
  ///
  /// Parameters:
  /// - [filePath]: The path of the file to determine the MIME type for.
  ///
  /// Returns:
  /// - The MIME type of the file as a string.
  String getMimeType(String filePath) {
    return lookupMimeType(filePath) ?? 'application/octet-stream';
  }
}
